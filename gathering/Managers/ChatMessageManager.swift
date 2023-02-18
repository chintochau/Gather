//
//  ChatMessageManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-17.
//

import Foundation
import PubNub

struct ChatMessageManager {
    static let shared = ChatMessageManager()
    
    let pubnub:PubNub = {
        let username = UserDefaults.standard.string(forKey: "username")
        
        let config = PubNubConfiguration(
            publishKey: "pub-c-1e30f6e1-a29f-4a4d-ac62-01bf0a141150",
            subscribeKey: "sub-c-bb25b314-3fc0-48d7-ae4a-5bd2ca17abf2",
            userId: username ?? "")
        return PubNub(configuration: config)
    }()
    
    let listener:SubscriptionListener = {
        let listener = SubscriptionListener()
        return listener
    }()
    
    
    
    
    // MARK: - Fetch ChannelIDs
    public func fetchChannelGroup(groupid:String, completion:@escaping ([String]) -> Void ) {
        
        pubnub.listChannels(for: groupid) { result in
            switch result {
            case .success(( _, let channels)):
                print(channels)
                listenToChannels(channels: channels)
                completion(channels)
            case .failure(_):
                completion([])
            }
        }
    }
    
    // MARK: - Listen to Channels
    public func listenToChannels(channels:[String]){
        let messageQueue = DispatchQueue(label: "pubnub-message-queue")
        
        listener.didReceiveMessage = { message in
            messageQueue.async {
                print("[Message]: \(message)")
            }
        }
        pubnub.add(listener)
        pubnub.subscribe(to: channels, withPresence: true)
        print("Listen to Channels: \(channels)")
    }
    
    public func listenToChannel(targetUsername:String) {
        let messageQueue = DispatchQueue(label: "pubnub-message-queue")
        
        let channelId = generateChannelIDFor(receiverUsername: targetUsername)
        
        listener.didReceiveMessage = { message in
            messageQueue.async {
                print("[Message]: \(message)")
            }
        }
        
        pubnub.add(listener)
        pubnub.subscribe(to: [channelId], withPresence: true)
        print("Listen to Channels: \(channelId)")
    }
    
    // MARK: - Send message, create channel and add to groups
    public func sendMessageAndAddToChannelGroup(targetUsername:String, message:String){
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        let channelId = generateChannelIDFor(receiverUsername: targetUsername)
        
        // Publish the message to the channel
        pubnub.publish(
            channel: channelId,
            message: ["text": message],
            completion: { result in
            switch result {
            case .success(_):
                pubnub.add(
                  channels: [channelId],
                  to: username
                ) { result in
                  switch result {
                    case let .success(response):
                      print("Success \(response)")
                      
                      pubnub.subscribe(
                        to: [channelId],
                        and: [username],
                        withPresence: true
                      )
                      

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
    
    
    // MARK: - Channel ID for 1 to 1 conversation
    public func generateChannelIDFor(receiverUsername:String) -> String{
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            print("Failed to create event ID")
            return ""
        }
        let sortedUsername = [username,receiverUsername].sorted()

        return "messages_\(sortedUsername[0])_to_\(sortedUsername[1])"
    }
    
}
