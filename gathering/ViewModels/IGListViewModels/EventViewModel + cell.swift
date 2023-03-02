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
    let location:String
    let intro:String?
    let tag: [EventTagType]?
    let participants:[Participant]
    let price:String
    let organiser:User?
    var image:UIImage? = nil
    
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
    
    var friends:[Participant] {
        RelationshipManager.shared.checkFriendList(with: participants)
    }
    
    var participantsExcludFriends:[Participant] {
        participants.filter { participant in
            !friends.contains { friend in
                participant.username == friend.username
            }
        }
    }
    
    var numberOfFriends:Int {
        friends.count
    }
    
    
    init(event: Event) {
        self.id = event.id
        self.event = event
        
        var maleCount = 0
        var femaleCount = 0
        var nonBinaryCount = 0
        
        self.participants = event.participants.compactMap({$0.value})
        
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
        
        
        
        // MARK: - Date
        var finalDateString:String = ""
        var startString:String = ""
        var endString:String = ""
        let startDateString = String.localeDate(from: event.startDateString, .zhHantTW)
        let endDateString = String.localeDate(from: event.endDateString, .zhHantTW)
        
        switch event.date {
        case ..<Date.tomorrowAtMidnight():
            startString = "今天"
        case ..<Date.tomorrowAtMidnight().adding(days: 1):
            startString = "明天"
        default:
            startString = startDateString.date ?? ""
        }
        
        switch event.endDate {
        case ..<Date.tomorrowAtMidnight():
            endString = "今天"
        case ..<Date.tomorrowAtMidnight().adding(days: 1):
            endString = "明天"
        default:
            endString = endDateString.date ?? ""
        }
        
        
        if startDateString == endDateString {
            // Same Day same time
            finalDateString = "\(startString)(\(startDateString.dayOfWeek ?? "")) \(startDateString.time ?? "")"
        }else if startDateString.date == endDateString.date {
            // same day different time
            finalDateString = "\(startString)(\(startDateString.dayOfWeek ?? "")) \(startDateString.time ?? "")-\(endDateString.time ?? "")"
        }else {
            
            finalDateString = "\(startString)(\(startDateString.dayOfWeek ?? ""))-\(endString)(\(endDateString.dayOfWeek ?? ""))"
        }
        
        
        self.dateString = finalDateString
        
        
        // MARK: - Others
        
        self.imageUrlString = event.imageUrlString.first
        self.title = event.title
        self.location = event.location.name
        self.tag = nil
        self.headcount = event.headcount
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


