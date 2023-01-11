//
//  Event.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import Foundation

enum EventType:Int {
    case normal = 1
    case homeParty = 2
}

struct Event:Codable {
    let id: String
    let title:String
    let host:String
    let imageUrlString:String
    let organisers:[String]?
    let eventType:Int // 1 normal
    let price: Double
    let dateString:String
    let location:String
    let tag:[String]?
    let detail:String?
    
    var date:Date {
        return DateFormatter.formatter.date(from: dateString) ?? Date()
    }
}
