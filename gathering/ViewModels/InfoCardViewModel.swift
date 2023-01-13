//
//  InfoCardViewModel.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-12.
//

import Foundation

enum InfoCardType {
    case time
    case location
    case refundPolicy
}

struct InfoCardViewModel {
    let title:String
    let subTitle:String
    let infoType:InfoCardType
}
