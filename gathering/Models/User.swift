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
    let rating:Double?
    let age:Int?
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
        self.rating = nil
        self.age = nil
        
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
