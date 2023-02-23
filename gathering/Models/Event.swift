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
    let startDateTimestamp:Double
    let endDateTimestamp:Double
    let location:Location
    let tag:[String]
    let introduction:String?
    let additionalDetail:String?
    let refundPolicy:String
    let participants:[String:Participant]
    let headcount:Headcount
    let ownerFcmToken:String?
    
    
    var startDate:Date {
        return Date(timeIntervalSince1970: startDateTimestamp)
    }
    var endDate:Date {
        return Date(timeIntervalSince1970: endDateTimestamp)
    }
    
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

extension Event {
    func headCountString () -> (total:String,male:String,female:String) {
        var maleCount = 0
        var femaleCount = 0
        var nonBinaryCount = 0
        
        self.participants.forEach { key,value in
            switch value.gender {
            case genderType.male.rawValue:
                maleCount += 1
            case genderType.female.rawValue:
                femaleCount += 1
            case genderType.nonBinary.rawValue:
                nonBinaryCount += 1
            default:
                print("case not handled")
            }
        }
        
        let headcount = self.headcount
        let total:String = headcount.max == 0 ? "" : "/\(headcount.max)"
        let female:String = headcount.fMax == 0 ? "" : "/\(headcount.fMax)"
        let male:String = headcount.mMax == 0 ? "" : "/\(headcount.mMax)"
        
        let totalString = "\(maleCount + femaleCount)\(total)"
        let maleString = "\(maleCount)\(male)"
        let femaleString = "\(femaleCount)\(female)"
        
        return (totalString,maleString,femaleString)
        
    }
}

struct Headcount:Codable {
    var isGenderSpecific:Bool = false
    var min:Int = 0
    var max:Int = 0
    var mMin:Int = 0
    var mMax:Int = 0
    var fMin:Int = 0
    var fMax:Int = 0
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
