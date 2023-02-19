//
//  Message.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-18.
//

import Foundation
import RealmSwift

class MessageObject: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var text = ""
    @Persisted var sentDate = Date()
    @Persisted var sender: UserObject?
    @Persisted var channelId:String

    var isIncoming:Bool {
        return sender?.username != UserDefaults.standard.string(forKey: "username")
    }
}
