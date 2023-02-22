//
//  RealmManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-19.
//

import Foundation
import RealmSwift
import Firebase

struct RealmManager {
    static let shared = RealmManager()
    
    
    func getObject<T: Object>(ofType type: T.Type, forPrimaryKey primaryKey: String) -> T? {
        let realm = try! Realm()
        let object = realm.object(ofType: type, forPrimaryKey: primaryKey)
        return object
    }
    
    func getObjectCreateIfNotExist<T: Object>(ofType type: T.Type, forPrimaryKey primaryKey: String) -> T {
        let realm = try! Realm()
        if let object = realm.object(ofType: type, forPrimaryKey: primaryKey) {
            return object
        } else {
            let newObject = T()
            newObject.setValue(primaryKey, forKey: T.primaryKey()!)
            try! realm.write {
                realm.add(newObject)
            }
            return realm.object(ofType: type, forPrimaryKey: primaryKey)!
        }
    }

    

    func fetchUserFromFirestore(userId: String,reload:Bool = false, completion: ((UserObject?, Error?) -> Void)? = nil) {
        // Get the default Realm instance
        let realm = try! Realm()
        
        // Check if the User object exists in the local Realm database
        if let user = realm.object(ofType: UserObject.self, forPrimaryKey: userId), !reload {
            // The User object already exists in local storage, return it
            completion?(user, nil)
            return
        }
        
        // The User object does not exist in local storage, fetch it from Firestore
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { snapshot, error in
            if let error = error {
                // Handle the error
                completion?(nil, error)
                return
            }
            
            guard let data = snapshot?.data() else {
                // The document does not exist in Firestore
                completion?(nil, NSError(domain: "FirestoreError", code: -1, userInfo: ["message": "User document not found"]))
                return
            }
            
            // Create a new User object from the Firestore data
            let user = UserObject(
                username: snapshot!.documentID,
                name: data["name"] as? String,
                profileUrlString: data["profileUrlString"] as? String
                
            )
            
            // Save the User object to the local Realm database
            try! realm.write {
                realm.add(user)
            }
            
            // Return the new User object
            completion?(user, nil)
        }
    }

    
    
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
