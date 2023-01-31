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
