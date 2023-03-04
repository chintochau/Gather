//
//  Notification.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-03.
//

import Foundation

struct Notification: Codable {
    var id: String = UUID().uuidString
    let type: NotificationType
    var createdAt: Double = Date().timeIntervalSince1970
    let sender:String
    let friendRequest: FriendRequest?
    let event: UserEvent?
}

enum NotificationType: String, Codable {
    case friendRequest
    case eventJoin
}

struct FriendRequest: Codable {
    let id: String
    let fromUser: User
    var createdAt: Double = Date().timeIntervalSince1970
}


