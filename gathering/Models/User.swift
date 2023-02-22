//
//  User.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import Foundation

struct User :Codable{
    let username:String
    let email:String
    let name:String?
    let profileUrlString:String?
    let gender:String?
    var rating:Double? = nil
    var age:Int? = nil
    var fcmToken:String? = nil
    var chatToken:String? = nil
    var happy:String? = nil
}

extension User {
    init?(with participant:Participant){
        guard let username = participant.username,
              let email = participant.email else {return nil}
        
        self.username = username
        self.email = email
        self.name = participant.name
        self.profileUrlString = participant.profileUrlString
        self.gender = participant.gender
    }
    
    
}

enum personalityType:String {
    case openness = "Openness"
    case conscientiousness = "Conscientiousness"
    case extraversion = "Extraversion"
    case agreeableness = "Agreeableness"
    case neuroticism = "Neuroticism"
}

enum genderType:String,CaseIterable {
    case male = "male"
    case female = "female"
    case nonBinary = "non binary"
}
