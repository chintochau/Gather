//
//  Event.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import Foundation
import SwiftDate

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
    let presetTags:[TagType]
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
    
}

extension Event {
    // MARK: - Computed properties
    
    var tags:[Tag] {
        var displayTags = [Tag]()
        for tagType in presetTags {
            displayTags.append(Tag(type: tagType))
        }
        
        if isJoined {
            displayTags.append(Tag(type: .joined))
        }
        
        if headcount.isGenderSpecific {
            let minMale: Int? = headcount.mMin ?? 0 > 0 ? headcount.mMin : nil
            let minFemale: Int? = headcount.fMin ?? 0 > 0 ? headcount.fMin : nil
            
            if minMale != nil || minFemale != nil {
                displayTags.append(Tag(type: .peoplCount,minMale: minMale,minFemale: minFemale,genderSpecific: headcount.isGenderSpecific))
                return displayTags
            }
            return displayTags
            
        } else {
            let minHeadcount:Int? = headcount.min ?? 0 > 0 ? headcount.min : nil
            
            if minHeadcount != nil {
                displayTags.append(Tag(type: .peoplCount,minHeadcount: minHeadcount,genderSpecific: headcount.isGenderSpecific))
                return displayTags
            }
            
            return displayTags
        }
        
        
        
    }
    
    var isJoined:Bool {
        guard let username = UserDefaults.standard.string(forKey: "username") else {return false}
        
        return participants.values.contains(where: {return $0.username == username
        })
    }
    
    var startDate:Date {
        return Date(timeIntervalSince1970: startDateTimestamp)
    }
    var endDate:Date {
        return Date(timeIntervalSince1970: endDateTimestamp)
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
    
    public func headCountString () -> (total:String,male:String,female:String, isMaleFull:Bool, isFemaleFull:Bool,isFull:Bool) {
        var maleCount = 0
        var femaleCount = 0
        var nonBinaryCount = 0
        
        self.participants.forEach { key,value in
            switch value.gender {
            case genderType.male.rawValue:
                maleCount += 1
            case genderType.female.rawValue:
                femaleCount += 1
//            case genderType.nonBinary.rawValue:
//                nonBinaryCount += 1
            default:
                print("case not handled")
            }
        }
        
        let headcount = self.headcount
        
        
        
        let total:String = {
            switch headcount.max {
            case nil:
                return ""
            case 0:
                return "hide"
            case let x where x! > 0:
                return "/\(x!)"
            default:
                fatalError()
            }
        }()

        let female:String = {
            switch headcount.fMax {
            case nil:
                return ""
            case 0:
                return "hide"
            case let x where x! > 0:
                return "/\(x!)"
            default:
                fatalError()
            }
        }()

        let male:String = {
            switch headcount.mMax {
            case nil:
                return ""
            case 0:
                return "hide"
            case let x where x! > 0:
                return "/\(x!)"
            default:
                fatalError()
            }
        }()
        
        var maleString = ""
        var femaleString = ""
        var totalString = ""
        
        let isMaleFull = maleCount >= headcount.mMax ?? 9999
        let isFemaleFull = femaleCount >= headcount.fMax ?? 9999
        let isFull = femaleCount >= headcount.max ?? 9999
        
        
        
        if headcount.mMax == 0 {
            maleString = "-"
        }else {
            maleString = "\(maleCount)\(male)"
        }
        
        
        if headcount.fMax == 0 {
            femaleString = "-"
        }else {
            femaleString = "\(femaleCount)\(female)"
        }
        
        if headcount.isGenderSpecific {
            
        }else {
            totalString = headcount.max == nil || headcount.max == 0 ? "" : "\(maleCount + femaleCount)\(total) "
        }
        
        
        return (totalString,maleString,femaleString,isMaleFull,isFemaleFull,isFull)
        
    }
    
    public func getDateString () -> String {
        // MARK: - Date
        var finalDateString:String = ""
        var startString:String = ""
        var endString:String = ""
        let startDateString = String.localeDate(from: startDateString, .zhHantTW)
        let endDateString = String.localeDate(from: endDateString, .zhHantTW)
        
        
        switch startDate {
        case ...Date.todayAtMidnight():
            startString = startDateString.relative
        case ...Date.tomorrowAtMidnight():
            startString = "今天"
        case ...Date.tomorrowAtMidnight().adding(days: 1):
            startString = "明天"
        default:
            startString = startDateString.date
        }
        
        switch endDate {
        case ...Date.todayAtMidnight():
            endString = endDateString.relative
        case ...Date.tomorrowAtMidnight():
            endString = "今天"
        case ...Date.tomorrowAtMidnight().adding(days: 1):
            endString = "明天"
        default:
            endString = endDateString.date
        }
        
        if startDateString == endDateString {
            // Same Day same time
            finalDateString = "\(startDateString.dayOfWeek),\(startString) \(startDateString.time)"
            
        }else if startDateString.date == endDateString.date {
            // same day different time
            finalDateString = "\(startDateString.dayOfWeek),\(startString) \(startDateString.time) - \(endDateString.time)"
            
        }else {
            
            finalDateString = "\(startDateString.dayOfWeek),\(startString) - \(endDateString.dayOfWeek),\(endString)"
        }
        
        return finalDateString
    }
    
    
    public func getDateDetailString () -> String {
        // MARK: - Date
        var finalDateString:String = ""
        var startString:String = ""
        var endString:String = ""
        let startDateString = String.localeDate(from: startDateString, .zhHantTW)
        let endDateString = String.localeDate(from: endDateString, .zhHantTW)
        
        
        switch startDate {
        default:
            startString = startDateString.date
        }
        
        switch endDate {
        default:
            endString = endDateString.date
        }
        
        if startDateString == endDateString {
            // Same Day same time
            finalDateString = "\(startDateString.dayOfWeek),\(startString) \(startDateString.time)"
            
        }else if startDateString.date == endDateString.date {
            // same day different time
            finalDateString = "\(startDateString.dayOfWeek),\(startString) \(startDateString.time) - \(endDateString.time)"
            
        }else {
            
            finalDateString = "\(startDateString.dayOfWeek),\(startString) \(startDateString.time)\n - \(endDateString.dayOfWeek),\(endString) \(endDateString.time)"
        }
        
        return finalDateString
    }
    
    
    public func getTimeString () -> String{
        // MARK: - Time
        let startDateString = String.localeDate(from: startDateString, .zhHantTW)
        let endDateString = String.localeDate(from: endDateString, .zhHantTW)
        
        if startDateString.time == endDateString.time {
            return startDateString.time
        }else {
            return "\(startDateString.time) - \(endDateString.time)"
        }
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
    
    func isEmpty () -> Bool {
        return [min,mMin,fMin].allSatisfy({$0 == 0})
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
            return "\n日期: \(date) (\(dayOfWeek))"
        }()
        
        let timeString:String = {
            if includeTime {
                return "\n時間: \(time)"
                
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
        
            var namelist = "\n報名: "
            for participant in event.participants {
                namelist += "\n\(counter). " + (participant.key == currentUsername ? currentName ?? "Not Valid" : participant.key)
                counter += 1
            }
            return namelist
        }()
        
        let deekLink:String = {
            return "\n\n\(EventDeeplinkHandler.generateEventDeepLink(with: event))"
        }()
        
        
        let string = emojiString + title + intro + deekLink + dateString +  timeString + location + address + participants
        return string
    }
}
