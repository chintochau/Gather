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
    let organisers:[User]
    let imageUrlString:[String]
    let price: Double
    let startDateString:String
    let endDateString:String
    let location:String
    let tag:[String]
    let description:String
    let refundPolicy:String
    let participants:[String:String]
    let separateGender:Bool
    let capacity:[Int]
    
    
    var date:Date {
        return DateFormatter.formatter.date(from: startDateString) ?? Date()
    }
    var priceString:String {
        return String(price)
    }
}

//struct Participant:Codable {
//    let name:String
//    let username:String
//    let gender:String
//    let email:String
//    
//}
//
//extension Participant {
//    init?(with user:User){
//        guard let name = user.name, let gender = user.gender else {
//            fatalError("Name / Gender is nil")}
//        self.name = name
//        self.username = user.username
//        self.gender = gender
//        self.email = user.email
//    }
//}
