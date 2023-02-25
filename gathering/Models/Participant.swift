//
//  Participants.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-30.
//

import Foundation



struct Participant:Codable {
    let name:String
    var username:String? = nil
    let gender:String
    var email:String? = nil
    var profileUrlString:String? = nil
    var status:Int
    
    enum participantStatus:Int {
        case going = 0
        case host = 1
        case waitList = 2
    }
    
}

extension Participant {
    init(with user:User,status:Int = 0){
        guard let name = user.name, let gender = user.gender else {
            fatalError("Name / Gender is nil")}
        self.name = name
        self.username = user.username
        self.gender = gender
        self.email = user.email
        self.profileUrlString = user.profileUrlString
        self.status = status
    }
    
}
