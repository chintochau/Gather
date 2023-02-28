//
//  EventDetailsViewModel.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-27.
//

import UIKit
import IGListKit

class EventDetails: ListDiffable {
    var id:String
    var name:String
    var owner:User?
    var dateString:String
    var timeString:String
    var locationString:String
    var intro:String?
    
    init (event:Event) {
        self.id = event.id
        self.name = event.title
        self.owner = event.organisers.first
        self.dateString = event.getDateString()
        self.timeString = event.getTimeString()
        self.locationString = event.location.name
        self.intro = event.introduction
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? EventDetails else {return false}
        return id == object.id
    }
}

class EventParticipants :ListDiffable {
    
    var id:String = UUID().uuidString
    var numberOfParticipants:String
    var numberOfMale:String
    var numberOfFemale:String
    
    init (participants: [Participant]) {
        var maleNumber = 0
        var femaleNumber = 0
        for participant in participants {
            switch participant.gender {
            case genderType.male.rawValue:
                maleNumber += 1
            case genderType.female.rawValue:
                femaleNumber += 1
            default:
                break
            }
        }
        
        self.numberOfMale = "\(maleNumber)"
        self.numberOfFemale = "\(femaleNumber)"
        self.numberOfParticipants = "\(maleNumber + femaleNumber)"
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object  = object as? EventParticipants else {return false}
        return id == object.id
    }
}
