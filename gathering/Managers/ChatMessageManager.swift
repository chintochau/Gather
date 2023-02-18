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
    
    
    
    // MARK: - Fetch Channel
    public func fetchChannelGroup(groupid:String, completion:@escaping ([String]) -> Void ) {
        // Check if group exists
        
        pubnub.listChannelGroups { result in
            
            switch result {
                
            case let .success(groups):
                
                if !groups.contains(groupid) {
                    createChannelGroup(groupid: groupid)
                }else {
                    pubnub.listChannels(for: groupid) { result in
                        switch result {
                        case .success(( _, let channels)):
                            completion(channels)
                        case .failure(_):
                            completion([])
                        }
                    }
                }
            case .failure(_):
                print("Faailed to list channel groups")
            }
        }
    }
    
    public func createChannelGroup(groupid:String){
        // Create the channel group
        pubnub.add(channels: [], to: groupid) { result in
            switch result {
            case .success:
                // Channel group created successfully
                print("Channel group created successfully")
            case let .failure(error):
                // Handle error
                print("Error creating channel group: \(error.localizedDescription)")
            }
        }
    }
    
    public func createChannelForGroup(channelID:String, groupID:String){
        
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
