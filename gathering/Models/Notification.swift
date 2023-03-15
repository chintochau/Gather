//
//  Notification.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-03.
//

import Foundation

struct GANotification: Codable {
    static let startDateString:String = "_startDate"
    static let endDateString:String = "_endDate"
    var id: String = UUID().uuidString
    let type: NotificationType
    var createdAt: Double = Date().timeIntervalSince1970
    let sentUser: SentUser?
    let event: UserEvent?
}

struct SentUser:Codable {
    let name:String?
    let username:String
}

extension User {
    func toSentUser() -> SentUser {
        return SentUser(name: self.name , username: self.username)
    }
}

enum NotificationType: String, Codable {
    case friendRequest
    case eventJoin
    case eventInvite
    case eventUpdate
    case friendAccept
}

/*
 struct User :Codable{
 let username:String
 let email:String?
 let name:String?
 let profileUrlString:String?
 let gender:String?
 var rating:Double? = nil
 var age:Int? = nil
 var fcmToken:String? = nil
 var chatToken:String? = nil
 var happy:String? = nil
 }
 */
