//
//  NewEvent.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-22.
//

import Foundation

//struct NewEvent {
//    var id:String = IdManager.shared.createEventId()
//    var emojiTitle:String? = nil
//    var title: String = ""
//    var description: String = ""
//    var startDate: Date = Date()
//    var endDate: Date = Date()
//    var location: Location = .toronto
//    var intro:String? = nil
//    var imageUrlString:String?
//    var headcount:Headcount = .init()
//    var participants:[String:Participant] = [:]
//    var eventRef:String? = nil
//}
//
//extension NewEvent {
//    
//    func toEvent (_ urlStrings:[String] = []) -> Event? {
//        guard let user = DefaultsManager.shared.getCurrentUser() else {return nil}
//        
//        return Event(id: self.id,
//                     emojiTitle: self.emojiTitle,
//                     title: self.title,
//                     organisers: [user],
//                     imageUrlString: urlStrings,
//                     price: 0,
//                     startDateTimestamp: self.startDate.timeIntervalSince1970,
//                     endDateTimestamp: self.endDate.timeIntervalSince1970,
//                     location: self.location,
//                     presetTags: [],
//                     introduction: self.intro,
//                     additionalDetail: nil,
//                     refundPolicy: "",
//                     participants: self.participants,
//                     headcount: self.headcount,
//                     ownerFcmToken: user.fcmToken)
//    }
//}


struct NewPost {
    
    
    var id:String = IdManager.shared.createEventId()
    var emojiTitle:String = UserDefaults.standard.string(forKey: "selectedEmoji") ?? "😃"
    var description: String = ""
    var intro:String? = nil
    var imageUrlString:String?
    var headcount:Headcount = .init()
    
    
    var title:String = ""
    var addInfo:String? = nil
    var startDate:Date = Date()
    var endDate:Date = Date()
    var headCount:Headcount = Headcount()
    var location:Location = .toBeConfirmed
    var participants:[String:Participant] = {
        guard let user = DefaultsManager.shared.getCurrentUser() else {
            return [:]
        }
        return [user.username:Participant(with: user)]
    }()
    var eventRef:String? = nil
}

extension NewPost {
    func toEvent (_ urlStrings:[String] = []) -> Event? {
        guard let user = DefaultsManager.shared.getCurrentUser() else {return nil}
        
        
        
        return Event(id: self.id,
                     emojiTitle: self.emojiTitle,
                     title: self.title,
                     organisers: [user],
                     imageUrlString: urlStrings,
                     price: 0,
                     startDateTimestamp: self.startDate.timeIntervalSince1970,
                     endDateTimestamp: self.endDate.timeIntervalSince1970,
                     location: self.location,
                     presetTags: [],
                     introduction: self.intro,
                     additionalDetail: nil,
                     refundPolicy: "",
                     participants: self.participants,
                     headcount: self.headcount,
                     ownerFcmToken: user.fcmToken)
    }
    
}

extension Event {
    func toNewPost()-> NewPost {
        return NewPost(
            id: self.id,
            emojiTitle: self.emojiTitle ?? "🤗",
            intro: self.introduction,
            imageUrlString: self.imageUrlString.first,
            headcount: self.headcount,
            title:self.title,
            addInfo:nil,
            startDate:self.startDate,
            endDate:self.endDate,
            headCount:self.headcount,
            location:self.location,
            participants:self.participants,
            eventRef: self.referencePath
        )
    }
}
