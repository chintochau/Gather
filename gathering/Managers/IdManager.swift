//
//  IdManager.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-16.
//

import Foundation

final class IdManager  {
    static let shared = IdManager()
    
    public func createEventId () -> String {
        guard let username = UserDefaults.standard.value(forKey: "username") else {return ""}
        let dateString = Date().timeIntervalSince1970
        let randomNumber = Int.random(in: 1...1000)
        return "\(username)_\(dateString)_\(randomNumber)"
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
    
    public func generateRelationshipIdFor(targetUsername:String) -> (id:String,user1:String,user2:String)?{
        guard let username = UserDefaults.standard.string(forKey: "username") else {fatalError()}
        
        let sortedUsername = [username, targetUsername].sorted()
        
        return (sortedUsername[0] + "_" + sortedUsername[1], sortedUsername[0],sortedUsername[1])
        
    }
    
}
