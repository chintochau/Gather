//
//  Event.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import Foundation

struct Event:Codable {
    let id: String
    let title:String
    let organisers:[String]
    let imageUrlString:[String]
    let price: Double
    let startDateString:String
    let endDateString:String
    let location:String
    let tag:[String]
    let description:String
    let refundPolicy:String
    let participants:[Participant]
    let separateGender:Bool
    let capacity:[Int]
    
    
    var date:Date {
        return DateFormatter.formatter.date(from: startDateString) ?? Date()
    }
}

struct Participant:Codable {
    let username:String
    let imageUrlString:String
    let gender:String
    let email:String
}
