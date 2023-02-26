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
    let dateTimeStamp:Double
    let location:Location
    var referencePath:String? = nil
}

extension Event {
    func toUserEvent () -> UserEvent {
        UserEvent(
            id: self.id,
            name: self.title,
            dateTimeStamp: self.startDateTimestamp,
            location: self.location,
            referencePath:self.referencePath
        )
        
    }
}
