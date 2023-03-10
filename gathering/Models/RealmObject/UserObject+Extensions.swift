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
    
    
    
    convenience init(username: String, name: String?, profileUrlString: String?) {
        self.init()
        self.username = username
        self.name = name
        self.profileUrlString = profileUrlString
    }
    
}

extension UserObject {
    func toUser() -> User {
        return User(username: username, email: "", name: name, profileUrlString: profileUrlString, gender: "")
    }
}

extension User {
    func realmObject() -> UserObject {
        
        let userObject = RealmManager.shared.createUserIfNotExist(username: username)
        
        let realm = try! Realm()
        try! realm.write {
            userObject.name = self.name
            userObject.profileUrlString = self.profileUrlString
        }
        return userObject
    }
    
    func getRelationshipObject() -> RelationshipObject? {
        let realm = try! Realm()
        let object = realm.object(ofType: RelationshipObject.self, forPrimaryKey: self.username)
        return object
    }
}
