//
//  ChatMessageManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-17.
//

import Foundation
import PubNub
import RealmSwift

struct ChatMessageManager {
    static let shared = ChatMessageManager()
    
    let pubnub:PubNub = {
        let username = UserDefaults.standard.string(forKey: "username") ?? "guest"
        let config = PubNubConfiguration(
            publishKey: "pub-c-1e30f6e1-a29f-4a4d-ac62-01bf0a141150",
            subscribeKey: "sub-c-bb25b314-3fc0-48d7-ae4a-5bd2ca17abf2",
            userId: username)
        return PubNub(configuration: config)
    }()
    
    let listener:SubscriptionListener = {
        let listener = SubscriptionListener()
        return listener
    }()
    
    
    // MARK: - Fetch ChannelIDs
    public func ConnectToChatServer(){
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        pubnub.listChannels(for: username) { result in
            switch result {
            case .success(( _, let channels)):
                listenToChannels(channels: channels)
                print("Connected to chatserver: \(username)")
            case .failure(_): break
            }
        }
    }
    
    public func disconnectFromChatServer(){
        pubnub.unsubscribeAll()
    }
    
    // MARK: - Listen to Channels
    public func listenToChannels(channels:[String]){
        let messageQueue = DispatchQueue(label: "pubnub-message-queue")
        
        listener.didReceiveMessage = { message in
            messageQueue.async {
                actionWhenReceiveMessage(message)
            }
        }
        
        pubnub.add(listener)
        pubnub.subscribe(to: channels, withPresence: true)
    }
    
    // MARK: - listen and Receive message
    public func listenToChannel(targetUsername:String) {
        
        let messageQueue = DispatchQueue(label: "pubnub-message-queue")
        
        let channelId = generateChannelIDFor(targetUsername: targetUsername)
        
        listener.didReceiveMessage = { message in
            messageQueue.async {
                
                actionWhenReceiveMessage(message)
            }
        }
        
        pubnub.add(listener)
        pubnub.subscribe(to: [channelId], withPresence: true)
    }
    
    
    
    // MARK: - Create Conversation
    /// create and return conversation realm object, add target user and self to participants, also create channel id
    public func createConversationIfNotExist(targetUsername:String) -> ConversationObject? {
        print(1)
        let realm = try! Realm()
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil}
        let channelid = generateChannelIDFor(targetUsername: targetUsername)
        
        if let conversation = realm.object(ofType: ConversationObject.self, forPrimaryKey: channelid) {
            
            print(2)
            return conversation
        } else {
            
            print(3)
            
            let user1 = RealmManager.shared.createUserIfNotExist(username: username)
            let user2 = RealmManager.shared.createUserIfNotExist(username: targetUsername)
            
            print(3.1)
            let conversation = ConversationObject()
            conversation.participants.append(objectsIn: [user1,user2])
            conversation.channelId = channelid
            
            print(4)
            try! realm.write({
                realm.add(conversation)
            })
            
            return realm.object(ofType: ConversationObject.self, forPrimaryKey: channelid)
            
        }
    }
    
    // when recive message
    public func onReceiveAndCreateConversationIfNotExist(sender:String,channelid:String) -> ConversationObject? {
        print(11)
        let realm = try! Realm()
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return nil}
        
        
        if let conversation = realm.object(ofType: ConversationObject.self, forPrimaryKey: channelid),
           sender == username {
            print(21)
            return conversation
        } else if let conversation = realm.object(ofType: ConversationObject.self, forPrimaryKey: channelid) {
            print(22)
            return conversation
            
        } else {
            
            print(31)
            let user1 = RealmManager.shared.createUserIfNotExist(username: username)
            let user2 = RealmManager.shared.createUserIfNotExist(username: sender)
            print(31.1)
            let conversation = ConversationObject()
            conversation.participants.append(objectsIn: [user1,user2])
            conversation.channelId = channelid
            
            print(41)
            try! realm.write({
                realm.add(conversation)
            })
            
            return realm.object(ofType: ConversationObject.self, forPrimaryKey: channelid)
            
        }
    }
    
    // MARK: - When receive message
    public func actionWhenReceiveMessage(_ PNmessage: PubNubMessage){
        print(PNmessage)
        if let text = PNmessage.payload[rawValue: "text"] as? String,
           let sender = PNmessage.publisher{
            
            let message = MessageObject()
            
            let user = RealmManager.shared.createUserIfNotExist(username: sender)
            print("create realm user \(user)")
            
            message.sender = user
            message.text = text
            message.sentDate = PNmessage.published.timetokenDate
            message.channelId = PNmessage.channel
            print("created message\(message)")
            addMessage(message)
        }
    }
    
    // MARK: - Add message Conversations
    func addMessage(_ message: MessageObject) {
        let realm = try! Realm()
        // Check if a conversation with the given ID already exists
        guard let senderUsername = message.sender?.username else {return}
        
        if let conversation = onReceiveAndCreateConversationIfNotExist(sender: senderUsername, channelid: message.channelId) {
            
            print(5)
            try! realm.write({
                conversation.messages.append(message)
            })
            
            triggerInAppNotification(message: message)
        }
    }
    
    
    // MARK: - Send message, create channel and add to groups
    public func sendMessageAndAddToChannelGroup(targetUsername:String, message:String){
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        print("receiver anme:\(targetUsername)")
        print("sender name:\(username)")
        let channelId = generateChannelIDFor(targetUsername: targetUsername)
        
        print("Send message and add to channel: \(channelId)")
        // Publish the message to the channel
        pubnub.publish(
            channel: channelId, message: ["text": message], completion: { result in
                switch result {
                case .success(_):
                    pubnub.add( channels: [channelId], to: username
                    ) { result in
                        switch result {
                        case let .success(response):
                            print("Success \(response)")
                            pubnub.subscribe( to: [channelId],and: [username],withPresence: true)
                        case let .failure(error):
                            print("failed: \(error.localizedDescription)")
                        }
                    }
                    
                    pubnub.add(channels: [channelId], to: targetUsername) { result in
                        switch result {
                        case let .success(response):
                            print("success\(response)")
                        case let .failure(error):
                            print("Failed: \(error.localizedDescription)")
                        }
                    }
                case let .failure(error):
                    print("Fail message: \(error)")
                }
            })
        
        
        
    }
    
    
    // MARK: - Channel ID
    public func generateChannelIDFor(targetUsername:String) -> String{
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("Failed to create event ID")
            return ""
        }
        let sortedUsername = [username,targetUsername].sorted()
        
        return "messages_\(sortedUsername[0])_to_\(sortedUsername[1])"
    }
    
    
    // MARK: - In-app notification
    public func triggerInAppNotification(message:MessageObject){
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let senderName = message.sender?.username,
              username != senderName else {return}
        
        let content = UNMutableNotificationContent()
        content.title = senderName
        content.body = message.text
        content.sound = UNNotificationSound.default
        content.userInfo = ["view": "MyViewController"]

        let request = UNNotificationRequest(identifier: "myNotification", content: content, trigger: nil)

        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            }
        }
    }
    
}
