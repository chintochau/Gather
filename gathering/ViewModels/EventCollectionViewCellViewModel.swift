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
    let capacity:[Int]
    let participants:[Participant]
}
