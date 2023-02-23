//
//  NewEvent.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-22.
//

import Foundation

struct NewEvent {
    var id:String = IdManager.shared.createEventId()
    var emojiTitle:String = UserDefaults.standard.string(forKey: "selectedEmoji") ?? "😃"
    var title: String = ""
    var description: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var location: Location = .toronto
    var detail:String = ""
    var imageUrlString:String?
    var headcount:Headcount = .init()
    var participants:[String:Participant] = [:]
}

extension NewEvent {
    
    func toEvent () -> Event? {
        guard let user = DefaultsManager.shared.getCurrentUser() else {return nil}
        
        return Event(id: self.id,
                     emojiTitle: self.emojiTitle,
                     title: self.title,
                     organisers: [user],
                     imageUrlString: [],
                     price: 0,
                     startDateTimestamp: self.startDate.timeIntervalSince1970,
                     endDateTimestamp: self.endDate.timeIntervalSince1970,
                     location: self.location,
                     tag: [],
                     introduction: self.detail,
                     additionalDetail: nil,
                     refundPolicy: "",
                     participants: self.participants,
                     headcount: self.headcount,
                     ownerFcmToken: user.fcmToken)
    }
}

