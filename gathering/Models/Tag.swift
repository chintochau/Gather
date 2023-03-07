//
//  Tag.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-06.
//

import UIKit

enum TagType:Int, Codable {
    case newFriend
    case newImmigrant
    case interests
    case peoplCount
    case joined
}

struct Tag : Codable{
    let type:TagType
    var minMale:Int? = nil
    var minFemale:Int? = nil
    var minHeadcount:Int? = nil
    var genderSpecific:Bool? = nil
    
    var maleString:String {
        if let minMale = minMale, minMale > 0 {
            return "\(minMale)男"
        }else {
            return ""
        }
    }
    
    var femaleString:String {
        if let minFemale = minFemale, minFemale > 0 {
            return "\(minFemale)女"
        }else {
            return ""
        }
    }
    
    var headcountString:String {
        if let minHeadcount = minHeadcount, minHeadcount > 0 {
            return "\(minHeadcount)人"
        }else {
            return ""
        }
    }
    
    var tagString:String {
        switch type {
        case .newFriend:
            return "認識新朋友"
        case .newImmigrant:
            return "新移民交流"
        case .peoplCount:
            if genderSpecific ?? false {
                return "成團人數: \(maleString)\(femaleString)"
            } else {
                return "成團人數: \(headcountString)"
            }
        case .joined:
            return "己報名"
        case .interests:
            return "興趣交流"
        }
    }
    
    var color: UIColor {
        switch type {
        case .newFriend:
            return .lightMainColor
        case .newImmigrant:
            return .darkMainColor
        case .peoplCount:
            return .darkMainColor
        case .joined:
            return .tiffBlueColor
        case .interests:
            return .darkSecondaryColor
        }
    }
}
