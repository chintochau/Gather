//
//  MockData.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import Foundation
import SDWebImage

struct MockData {
    
    static let event = Event(
        id: "123321",
        title: "Photo Day",
        organisers: [user],
        imageUrlString: ["https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZXZlbnR8ZW58MHx8MHx8&w=1000&q=80"],
        price: 123.4,
        startDateString: String.date(from: Date()) ?? "NOW",
        endDateString: String.date(from: Date()) ?? "NOW",
        location: "Hong Kong", tag: ["Jason","Marco"],
        description: "Join us to have happy dinner together!!Join us to have happy dinner together!!Join us to have happy dinner together!!Join us to have happy dinner together!!Join us to have happy dinner together!!Join us to have happy dinner together!!Join us to have happy dinner together!!",
        refundPolicy: "No Refund",
        participants: [:
        ],
        separateGender: true,
        capacity: [10,10]
        
    )
    
    static let user = User(
        username: "mockuser001",
        email: "MockUser@Example.com",
        name: "Mock User",
        profileUrlString: "https://media1.popsugar-assets.com/files/thumbor/hnVKqXE-xPM5bi3w8RQLqFCDw_E/475x60:1974x1559/fit-in/2048xorig/filters:format_auto-!!-:strip_icc-!!-/2019/09/09/023/n/1922398/9f849ffa5d76e13d154137.01128738_/i/Taylor-Swift.jpg",
        hobbies: nil,
        gender: "female")
    
    
    
}
