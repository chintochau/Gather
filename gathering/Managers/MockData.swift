//
//  MockData.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import Foundation

struct MockData {
    static let event = Event(id: "123321", title: "Photo Day", host: "Jason", imageUrlString: "https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZXZlbnR8ZW58MHx8MHx8&w=1000&q=80", organisers: ["Jason","Chau"], eventType: 1, price: 123.4, dateString: String.date(from: Date()) ?? "NOW", location: "Hong Kong", tag: ["Jason","Marco"], detail: nil)
}
