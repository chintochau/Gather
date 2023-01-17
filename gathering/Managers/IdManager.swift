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
    
}
