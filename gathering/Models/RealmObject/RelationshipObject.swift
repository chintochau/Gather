//
//  RelationshipObject.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import UIKit
import RealmSwift

enum relationshipType:Int {
    case noRelation = 0
    case pending = 1
    case received = 2
    case friend = 3
    case blocked = 4
}

class RelationshipObject: Object, Codable {
    
    @Persisted var id = ""
    @Persisted(primaryKey: true) var targetUsername:String = ""
    @Persisted var selfUsername:String = ""
    @Persisted var status:Int = 0
    @Persisted var relationshipScore:Double = 0
    @Persisted var date = Date()
    
    var targetUser: UserObject? {
        let realm  = try! Realm()
        return realm.object(ofType: UserObject.self, forPrimaryKey: targetUsername)
    }
    
    
}
