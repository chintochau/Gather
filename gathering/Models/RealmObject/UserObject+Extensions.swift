//
//  UserObject.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-18.
//

import Foundation
import RealmSwift

class UserObject: Object{
    @Persisted(primaryKey: true) var username:String
    @Persisted var name:String?
    @Persisted var profileUrlString:String?
    
    let conversations = LinkingObjects(fromType: ConversationObject.self, property: "participants")
}

extension User {
    func realmObject() -> UserObject {
        let userObject = UserObject()
        userObject.username = self.username
        userObject.name = self.name
        userObject.profileUrlString = self.profileUrlString
        return userObject
    }
}
