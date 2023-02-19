//
//  RealmManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-19.
//

import Foundation
import RealmSwift

struct RealmManager {
    static let shared = RealmManager()
    
    
    
    public func createUserIfNotExist(username:String) -> UserObject{
        
        let realm = try! Realm()
        if let user = realm.object(ofType: UserObject.self, forPrimaryKey: username) {
            return user
        }else {
            let user = UserObject()
            user.username = username
            try! realm.write({
                realm.add(user)
            })
            return realm.object(ofType: UserObject.self, forPrimaryKey: user.username)!
        }
    }
    
    public func clearRealmDatabase(){
        // Get the default Realm configuration
        let configuration = Realm.Configuration.defaultConfiguration

        // Get the URL of the Realm file
        guard let fileURL = configuration.fileURL else {
            return
        }

        // Delete the Realm file
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting Realm file: \(error)")
        }
    }
}
