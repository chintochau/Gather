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
    let participants:[Participant]
    let price:String
    let organiser:User?
    
    var isOrganiser:Bool = false
    var isJoined:Bool = false
    
    let headcount:Headcount
    
    let maleString:String
    let femaleString:String
    let totalString:String
    
    let peopleCount: (male:Int, female:Int)
    var totalPeopleCount:Int {
        peopleCount.male + peopleCount.female
    }
    
    
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
        let headcount = event.headcount
        let total:String = headcount.max == 0 ? "" : "/\(headcount.max)"
        let female:String = headcount.fMax == 0 ? "" : "/\(headcount.fMax)"
        let male:String = headcount.mMax == 0 ? "" : "/\(headcount.mMax)"
        
        
        self.totalString = "\(maleCount + femaleCount)\(total)"
        self.maleString = "\(maleCount)\(male)"
        self.femaleString = "\(femaleCount)\(female)"
        
        
        if event.price == 0 {
            self.price = "Free"
        }else {
            self.price = "CA$: \(event.price)"
        }
        
        
        let fullDateString = String.localeDate(from: event.startDateString, .enUS)
        self.dateString = fullDateString.date ?? ""
        self.dayString = fullDateString.dayOfWeek ?? ""
        self.timeString = fullDateString.time ?? ""
        self.imageUrlString = event.imageUrlString.first
        self.title = event.title
        self.location = event.location.name
        self.tag = nil
        self.headcount = event.headcount
        self.participants = []
        self.peopleCount = (male:maleCount, female:femaleCount)
        
        
        
        self.emojiString = event.emojiTitle
        self.intro = event.introduction
        self.organiser = event.organisers.first
        
        
        guard let username = UserDefaults.standard.string(forKey: "username") else {return}
        
        self.isOrganiser = self.organiser?.username == username
        
        self.isJoined = event.participants.values.contains(where: {return $0.username == username
        })
        
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


