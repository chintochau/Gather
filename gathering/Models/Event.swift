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
    let startDate:Date
    let endDate:Date
    let location:Location
    let tag:[String]
    let introduction:String?
    let additionalDetail:String?
    let refundPolicy:String
    let participants:[String:Participant]
    let headcount:Headcount
    let ownerFcmToken:String?
    
    
    var date:Date {
        return DateFormatter.formatter.date(from: startDateString) ?? Date()
    }
    var startDateString:String {
        return String.date(from: startDate) ?? "Now"
    }
    
    var endDateString:String {
        return String.date(from: endDate) ?? "Now"
    }
    
    var priceString:String {
        return String(price)
    }
}


struct Headcount:Codable {
    var isGenderSpecific:Bool = false
    var min:Int? = nil
    var max:Int? = nil
    var mMin:Int? = nil
    var mMax:Int? = nil
    var fMin:Int? = nil
    var fMax:Int? = nil
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






extension Event {
    func toString () -> String {
        let event = self
        
        let emojiTitle:String = event.emojiTitle ?? ""
        
        let title:String = emojiTitle + " " + event.title
        
        let startString:String = {
            return "\nTime: " + event.startDateString
        }()
        
        let location:String = {
            return "\nLocation: " + event.location.name
        }()
        
        let address:String = {
            if let address = event.location.address {
                return "\nAddress: " + address
            }
            return ""
        }()
        
        let participants:String = {
            let user = DefaultsManager.shared.getCurrentUser()
            
            let currentUsername = user?.username
            let currentName = user?.name
            
            var counter:Int = 1
        
            var namelist = "\nNamelist: "
            for participant in event.participants {
                namelist += "\n\(counter). " + (participant.key == currentUsername ? currentName ?? "Not Valid" : participant.key)
                counter += 1
            }
            return namelist
        }()
        let string = title + startString + location + address + participants
        return string
    }
}
