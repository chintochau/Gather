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
    
    
    var dateString:String {
        let date = Date(timeIntervalSince1970: dateTimeStamp)
        
        let dateString = String.localeDate(from: date, .zhHantTW)
        
        return dateString.date
    }
}

extension UserEvent {
    public func toViewModel() -> UserEventViewModel {
        
        return UserEventViewModel(title: "活動: \(self.name)", location: "地點: \(self.location.name)", date: "日期: \(self.dateString)")
    }
}

struct UserEventViewModel {
    let title:String
    let location:String
    let date:String
}

extension Event {
    // MARK: - public functions
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
