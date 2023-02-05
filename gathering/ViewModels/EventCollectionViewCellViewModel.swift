//
//  EventCollectionViewCellViewModel.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

enum EventTagType {
    case new
    case featured
}

struct EventCollectionViewCellViewModel {
    let imageUrlString:String
    let title:String
    let date:String
    let location:String
    let tag: [EventTagType]?
    let isLiked: Bool
    let isSeparated:Bool
    let headcount:Headcount
    let totalCapacity:Int
    let participants:[String:String]
    let peopleCount: (male:Int, female:Int)
    let price:Double
    let totalPeopleCount:Int
    
    var priceString:String {
        return String(price)
    }
}


extension EventCollectionViewCellViewModel {
    
    init(with event:Event) {
        
        var maleCount = 0
        var femaleCount = 0
        var nonBinaryCount = 0
        
        event.participants.forEach({
            switch $0.value{
            case "male":
                maleCount += 1
            case "female":
                femaleCount += 1
            case "non binary":
                nonBinaryCount += 1
            default :
                print("case no handled")
            }
            
        })
        
//        for joiner in event.participants {
//            if joiner.gender == "male" {
//                maleCount += 1
//            }
//            if joiner.gender == "famel" {
//                femaleCount += 1
//            }
//        }
        
        self.imageUrlString = event.imageUrlString.first ?? ""
        self.title = event.title
        self.date = event.startDateString
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
    }
}
