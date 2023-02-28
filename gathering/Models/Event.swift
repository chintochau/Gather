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
    
    /// "events/{YearWeek}"
    var referencePath:String? = nil
    /// "{YearMonth}"
    var referencePathForUser:String? = nil
    
    
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
    // MARK: - Public functions
    
    public func headCountString () -> (total:String,male:String,female:String) {
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
    
    public func getDateString () -> String {
        // MARK: - Date
        var finalDateString:String = ""
        var startString:String = ""
        var endString:String = ""
        let startDateString = String.localeDate(from: startDateString, .zhHantTW)
        let endDateString = String.localeDate(from: endDateString, .zhHantTW)
        
        switch date {
        case ..<Date.tomorrowAtMidnight():
            startString = "今天"
        case ..<Date.tomorrowAtMidnight().adding(days: 1):
            startString = "明天"
        default:
            startString = startDateString.date ?? ""
        }
        
        switch endDate {
        case ..<Date.tomorrowAtMidnight():
            endString = "今天"
        case ..<Date.tomorrowAtMidnight().adding(days: 1):
            endString = "明天"
        default:
            endString = endDateString.date ?? ""
        }
        
        
        if startDateString == endDateString {
            finalDateString = "\(startString)(\(startDateString.dayOfWeek ?? ""))"
        }else if startDateString.date == endDateString.date {
            finalDateString = "\(startString)"
        }else {
            finalDateString = "\(startString) - \(endString) "
        }
        
        return finalDateString
    }
    
    public func getTimeString () -> String{
        // MARK: - Time
        let startDateString = String.localeDate(from: startDateString, .zhHantTW)
        let endDateString = String.localeDate(from: endDateString, .zhHantTW)
        
        if startDateString.time == endDateString.time {
            return startDateString.time ?? ""
        }else {
            return "\(startDateString.time ?? "") - \(endDateString.time ?? "")"
        }
    }
    
    public func getDateAndTimeString () -> String{
        // MARK: - Date and Time
        var finalDateAndTimeString:String = ""
        var startString:String = ""
        var endString:String = ""
        let startDateString = String.localeDate(from: startDateString, .zhHantTW)
        let endDateString = String.localeDate(from: endDateString, .zhHantTW)
        
        switch date {
        case ..<Date.tomorrowAtMidnight():
            startString = "今天"
        case ..<Date.tomorrowAtMidnight().adding(days: 1):
            startString = "明天"
        default:
            startString = startDateString.date ?? ""
        }
        
        switch endDate {
        case ..<Date.tomorrowAtMidnight():
            endString = "今天"
        case ..<Date.tomorrowAtMidnight().adding(days: 1):
            endString = "明天"
        default:
            endString = endDateString.date ?? ""
        }
        
        
        if startDateString == endDateString {
            finalDateAndTimeString = "\(startString)(\(startDateString.dayOfWeek ?? "")) \(startDateString.time ?? "")"
        }else if startDateString.date == endDateString.date {
            finalDateAndTimeString = "\(startString) \(startDateString.time ?? "") - \(endDateString.time ?? "")"
        }else {
            finalDateAndTimeString = "\(startString) \(startDateString.time ?? "") - \(endString) \(endDateString.time ?? "")"
        }
        
        return finalDateAndTimeString
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
    
    func isEmpty () -> Bool {
        return [min,mMin,fMin].allSatisfy({$0 == 0})
    }
    
    var range:String {
        "\(min) ~ \(max)"
    }
    var maleRange:String {
        "\(mMin) ~ \(mMax)"
    }
    var femaleRange:String {
        "\(fMin) ~ \(fMax)"
    }
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
    func toString (includeTime:Bool) -> String {
        let event = self
        
        
        
        let emojiString:String = {
            if let emojiString = event.emojiTitle {
                return emojiString + " "
            }else {
                return ""
            }
        }()
        
        let title:String = "\(event.title) \n"
        
        let intro:String = {
            if let intro = event.introduction {
                return "\(intro)\n"
            }else {
                return ""
            }
        }()
        
        let localeDate = String.localeDate(from: event.startDateString, .zhHantTW)
        
        let date = localeDate.date
        let dayOfWeek = localeDate.dayOfWeek
        let time = localeDate.time
        
        let dateString:String = {
            return "\n日期: \(date!) (\(dayOfWeek!))"
        }()
        
        let timeString:String = {
            if includeTime {
                return "\n時間: \(time!)"
                
            } else {
                return ""
            }
        }()
        
        let location:String = {
            return "\n地點: " + event.location.name
        }()
        
        let address:String = {
            if let address = event.location.address {
                return ", " + address
            }
            return ""
        }()
        
        let participants:String = {
            let user = DefaultsManager.shared.getCurrentUser()
            
            let currentUsername = user?.username
            let currentName = user?.name
            
            var counter:Int = 1
        
            var namelist = "\n接龍: "
            for participant in event.participants {
                namelist += "\n\(counter). " + (participant.key == currentUsername ? currentName ?? "Not Valid" : participant.key)
                counter += 1
            }
            return namelist
        }()
        let string = emojiString + title + intro + dateString +  timeString + location + address + participants
        return string
    }
}
