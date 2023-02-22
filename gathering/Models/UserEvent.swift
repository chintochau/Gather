//
//  UserEvent.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-22.
//

import Foundation


struct UserEvent:Codable {
    let id:String
    let name:String
    let date:Date
    let location:Location
}

extension Event {
    func toUserEvent () -> UserEvent {
        UserEvent(id: self.id, name: self.title, date: self.startDate, location: self.location)
        
    }
}
