//
//  DatabaseManager.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-13.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let database = Firestore.firestore()
    
    /// to create user profile when user first login the app
    public func createUserProfile(newUser:User, completion: @escaping (Bool) -> Void) {
        
        let ref = database.collection("users").document(newUser.username)
        
        guard let data = newUser.asDictionary() else {return}
        ref.setData(data) { error in
            completion(error == nil)
        }
    }
    
    // MARK: - Find User
    public func findUserWithEmail(with email:String, completion: @escaping (User?) -> Void) {
        
        let ref = database.collection("users")
        
        let query = ref.whereField("email", isEqualTo: email)
        
        query.getDocuments { snapshots, error in
            guard let users = snapshots?.documents else {
                completion(nil)
                return
            }
            let user = users.compactMap({ User(with: $0.data())}).first
            
            completion(user)
        }
    }
    public func findUserWithUsername(with username:String, completion: @escaping (User?) -> Void) {
        
        let ref = database.collection("users").document(username)
        
        ref.getDocument { snapshot, error in
            guard let data = snapshot?.data(),let user = User(with: data) else {
                completion(nil)
                return}
            
            completion(user)
            
            
        }
        
    }
}
