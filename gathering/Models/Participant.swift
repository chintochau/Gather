//
//  Participants.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-30.
//

import Foundation

struct Participant:Codable {
    let name:String
    let username:String?
    let gender:String
    let contact:String

}

extension Participant {
    init(with user:User){
        guard let name = user.name, let gender = user.gender else {
            fatalError("Name / Gender is nil")}
        self.name = name
        self.username = user.username
        self.gender = gender
        self.contact = user.email
    }
    
    
    
}
