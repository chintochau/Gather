//
//  EventDetailsViewModel.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-27.
//

import UIKit
import IGListKit

class EventDetailsViewModel: ListDiffable {
    var id:String
    var name:String
    var owner:User?
    var dateString:String
    var timeString:String
    var locationString:String
    var intro:String?
    var location:Location
    
    init (event:Event) {
        self.id = event.id
        self.name = event.title
        self.owner = event.organisers.first
        self.dateString = event.getDateDetailString()
        self.timeString = event.getTimeString()
        
        var addressString = event.location.name
        if let address = event.location.address {
            addressString += "\n\(address)"
        }
        
        self.locationString = addressString
        self.intro = event.introduction
        self.location = event.location
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? EventDetailsViewModel else {return false}
        return id == object.id
    }
}

class EventParticipants :ListDiffable {
    
    var id:String = UUID().uuidString
    var numberOfParticipants:String
    var numberOfMale:String
    var numberOfFemale:String
    var friends:[Participant]
    var numberOfFriends:String
    var participants:[Participant]
    
    
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
        
        
        self.friends = RelationshipManager.shared.checkFriendList(with: participants)
        
        
        self.numberOfFriends = friends.count > 0 ? "你有\(friends.count)個朋友參加左" : "參加者: "
        
        self.participants = participants
        
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object  = object as? EventParticipants else {return false}
        return id == object.id
    }
}
