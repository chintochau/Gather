//
//  Event.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import Foundation

struct Event:Codable {
    let id: String
    let emojiTitle:String?
    let title:String
    let organisers:[User]
    let imageUrlString:[String]
    let price: Double
    let startDateString:String
    let endDateString:String
    let location:Location
    let tag:[String]
    let introduction:String?
    let additionalDetail:String?
    let refundPolicy:String
    let participants:[String:String]
    let headcount:Headcount
    
    
    var date:Date {
        return DateFormatter.formatter.date(from: startDateString) ?? Date()
    }
    var priceString:String {
        return String(price)
    }
}

struct Headcount:Codable {
    let isGenderSpecific:Bool
    let min:Int?
    let max:Int?
    let mMin:Int?
    let mMax:Int?
    let fMin:Int?
    let fMax:Int?
}


enum hobbyType:String,CaseIterable {
    case outdoor = "Outdoor Activity"
    case sports = "Sports"
    case travel = "Travel"
    case arts = "Traditional Arts"
    case creative = "Creative Hobbies"
    case crafting = "Crafting"
    case food = "Food & Cooking"
    case games = "Games"
    case spiritual = "Spiritual & Self Improve"
    case videoGames = "Video Games"
    case animals = "Pets"
}

enum eventType:String,CaseIterable {
    case formEvent = "Form an Event"
    case newEvent = "Post an Event"
}


