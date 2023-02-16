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
    let startTimestamp:Double
    let endTimestamp:Double
    let location:Location
    let tag:[String]
    let introduction:String?
    let additionalDetail:String?
    let refundPolicy:String
    let participants:[String:String]
    let headcount:Headcount
    let ownerFcmToken:String?
    
    
    var date:Date {
        return DateFormatter.formatter.date(from: startDateString) ?? Date()
    }
    var startDateString:String {
        return String.date(from: Date(timeIntervalSince1970: startTimestamp)) ?? "Now"
    }
    
    var endDateString:String {
        return String.date(from: Date(timeIntervalSince1970: endTimestamp)) ?? "Now"
        
    }
    
    var priceString:String {
        return String(price)
    }
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

