//
//  HomeEventCellViewModel.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import UIKit
import IGListKit

enum EventTagType {
    case new
    case featured
}

class EventHomeCellViewModel: HomeCellViewModel {
    // Basic
    let id: String
    let event: Event
    let imageUrlString:String?
    let emojiString:String?
    let title:String
    let dateString:String
    let dayString:String
    let timeString:String
    let location:String
    let intro:String?
    let tag: [EventTagType]?
    let isLiked: Bool
    let isSeparated:Bool
    let headcount:Headcount
    let totalCapacity:Int
    let participants:[String:String]
    let peopleCount: (male:Int, female:Int)
    let price:Double
    let totalPeopleCount:Int
    let organiser:User
    
    
    init(event: Event) {
        self.id = event.id
        self.event = event
        
        var maleCount = 0
        var femaleCount = 0
        var nonBinaryCount = 0
        
        event.participants.forEach { key,value in
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
        
        let fullDateString = String.localeDate(from: event.startDateString, .enUS)
        self.dateString = fullDateString.date ?? ""
        self.dayString = fullDateString.dayOfWeek ?? ""
        self.timeString = fullDateString.time ?? ""
        self.imageUrlString = event.imageUrlString.first
        self.title = event.title
        self.location = event.location.name
        self.tag = nil
        self.isLiked = false
        self.headcount = event.headcount
        self.isSeparated = event.headcount.isGenderSpecific
        self.participants = [:]
        self.peopleCount = (male:maleCount, female:femaleCount)
        self.totalPeopleCount = peopleCount.male + peopleCount.female
        self.price = event.price
        self.totalCapacity = event.headcount.max ?? 0
        self.emojiString = event.emojiTitle
        self.intro = event.introduction
        self.organiser = event.organisers.first!
        
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let other = object as? EventHomeCellViewModel else { return false }
        return event.id == other.event.id
    }
    
    // Additional properties and methods for the event view model
}



struct EventCellViewModel {
    let imageUrlString:String?
    let emojiString:String?
    let title:String
    let dateString:String
    let dayString:String
    let timeString:String
    let location:String
    let intro:String?
    let tag: [EventTagType]?
    let isLiked: Bool
    let isSeparated:Bool
    let headcount:Headcount
    let totalCapacity:Int
    let participants:[String:String]
    let peopleCount: (male:Int, female:Int)
    let price:Double
    let totalPeopleCount:Int
    let organiser:User
    
    var priceString:String {
        return price == 0 ? "Free" : "CA$: " + String(price)
    }
}


extension EventCellViewModel {
    
    init(with event:Event) {
        
        var maleCount = 0
        var femaleCount = 0
        var nonBinaryCount = 0
        
        event.participants.forEach { key,value in
        }
        
//        event.participants.forEach({
//            switch $0.value{
//            case "male":
//                maleCount += 1
//            case "female":
//                femaleCount += 1
//            case "non binary":
//                nonBinaryCount += 1
//            default :
//                print("case no handled")
//            }
//
//        })
        
        let fullDateString = String.localeDate(from: event.startDateString, .enUS)
        
        self.dateString = fullDateString.date ?? ""
        self.dayString = fullDateString.dayOfWeek ?? ""
        self.timeString = fullDateString.time ?? ""
        
        self.imageUrlString = event.imageUrlString.first
        self.title = event.title
        self.location = event.location.name
        self.tag = nil
        self.isLiked = false
        self.headcount = event.headcount
        self.isSeparated = event.headcount.isGenderSpecific
        self.participants = [:]
        self.peopleCount = (male:maleCount, female:femaleCount)
        self.totalPeopleCount = peopleCount.male + peopleCount.female
        self.price = event.price
        self.totalCapacity = event.headcount.max ?? 0
        self.emojiString = event.emojiTitle
        self.intro = event.introduction
        self.organiser = event.organisers.first!
    }
}
