//
//  DatabaseManager.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-13.
//

import Foundation
import FirebaseFirestore
import FirebaseMessaging

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let database = Firestore.firestore()
    
    // MARK: - User Profile
    /// to create user profile when user first login the app
    public func createUserProfile(newUser:User, completion: @escaping (Bool) -> Void) {
        
        let ref = database.collection("users").document(newUser.username)
        guard let data = newUser.asDictionary() else {return}
        ref.setData(data) { error in
            completion(error == nil)
        }
    }
    
    public func updateUserProfile(user:User, completion: @escaping (User) -> Void) {
        var user = user
        
        if let fcmToken = Messaging.messaging().fcmToken {
            user.fcmToken = fcmToken
        }
        
        let ref = database.collection("users").document(user.username)
        
        guard let data = user.asDictionary() else {return}
        ref.updateData(data) { [weak self] error in
            
            self?.findUserWithUsername(with: user.username) { user in
                guard let user = user else {return}
                completion(user)
                
                
            }
            
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
    
    public func searchForUsers(with username:String, completion: @escaping ([User]) -> Void) {
        
        
        let ref = database.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: username.lowercased())
            .whereField("username", isLessThanOrEqualTo: "\(username.lowercased())~")
        
        ref.getDocuments { snapshot, error in
            
            guard let users = snapshot?.documents.compactMap({ User(with: $0.data()) }) else {return}
            
            completion(users)
            
        }
        
        
    }
    
    // MARK: - Create Event
    public func createEvent (with event:Event, completion: @escaping (Bool) -> Void) {
        database.runTransaction {[weak self] transaction, error in
            guard let eventRef = self?.database.collection("events").document(event.id),
                  let eventData = event.asDictionary(),
                  let user = DefaultsManager.shared.getCurrentUser(),
                  let userEventRef = self?.database.collection("users").document(user.username).collection("events").document(event.startDate.getYearMonth())
            else {return}
            transaction.setData(eventData, forDocument: eventRef)
            transaction.setData([
                "month": event.startDate.getMonthInDate().timeIntervalSince1970,
                event.id: event.toUserEvent().asDictionary()!
            ], forDocument: userEventRef,merge: true)
            return nil
        } completion: { (_,error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                completion(true)
                print("Transaction successfully committed!")
            }
        }
        
    }
    
    // MARK: - Read Event
    public func fetchAllEvents(exclude excludeEvents:[Event] = [],completion: @escaping ([Event]?) -> Void) {
        
        let excludedEventIDs = excludeEvents.compactMap({$0.id})
        
        let ref = database.collection("events")
        ref.getDocuments { snapshot, error in
            
            guard let events = snapshot?.documents.compactMap({ Event(with: $0.data()) }) else {
                completion(nil)
                return
            }
            
            let filterEvents = events.filter { event in
                return !excludedEventIDs.contains(event.id)
            }
            
            completion(filterEvents)
        }
    }
    
    public func fetchParticipants(with eventID:String, completion:@escaping ([Participant]?) -> Void ) {
        let ref = database.collection("events").document(eventID).collection("participants")
        
        ref.getDocuments { snapshot, error in
            guard let participants = snapshot?.documents.compactMap({ Participant(with: $0.data()) }) else {
                completion(nil)
                return
            }
            completion(participants)
            
        }
        
    }
    
    // MARK: - UpdateEvents
    
    public func registerEvent(participant: User,eventID:String,eventStarttimestamp:Date,completion:@escaping (Bool) -> Void){
        
        let gender = participant.gender
        
        guard let participant = participant.asDictionary(),
              let username = UserDefaults.standard.string(forKey: "username")
        else {
            completion(false)
            print("Failed to register event")
            return}
        
        let ref = database.collection("events").document(eventID)
        ref.collection("participants").document(username).setData(participant)
        
        /// use dictionary
        ref.setData([
            "participants" : [username:gender]
        ], merge: true) {[weak self] error in
            guard error == nil else {
                completion(false)
                return}
            
            let selfRef = self?.database.collection("users").document(username).collection("events")
            selfRef?.document(eventID)
                .setData(["id" : eventID,
                          "startTimestamp":eventStarttimestamp],
                         completion: { error in
                    completion(error == nil)
                })
            
        }
        /*
         participants (map)
         {jason:male,
         jackie:female}
        */
        
        /// use Array
        //        ref.updateData([
        //            "participants" : FieldValue.arrayUnion([participant])
        //        ]) { error in
        //            completion(error == nil)
        //        }
        /*
         participants (array)
         [0] jason:male
         [1] jackie:female
        */
        
    }
    
    // MARK: - Delete Events
    public func unregisterEvent(eventID:String, completion:@escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username")
        else {
            completion(false)
            print("Failed to retrive username")
            return}
        
        let ref = database.collection("events").document(eventID)
        ref.collection("participants").document(username).delete()
        
        ref.setData([
            "participants" : [username:FieldValue.delete()]
        ], merge: true)
        
        
    }
    
    
    // MARK: - Friends
    
    public func sendFriendRequest(targetUsername:String){
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let relationshipString = IdManager.shared.generateRelationshipIdFor(targetUsername: targetUsername)
        else {return}
        
        let targetRef = database.collection("users").document(targetUsername).collection("relationship").document(username)
        let selfRef = database.collection("users").document(username).collection("relationship").document(targetUsername)
        
        
        let batch  = database.batch()
        let relationshipObject = RelationshipObject()
        relationshipObject.id = relationshipString.id
        
        // write to target
        relationshipObject.targetUsername = username
        relationshipObject.selfUsername = targetUsername
        relationshipObject.status = relationshipType.received.rawValue
        batch.setData(relationshipObject.asDictionary()!, forDocument: targetRef)
        
        // write to self
        relationshipObject.targetUsername = targetUsername
        relationshipObject.selfUsername = username
        relationshipObject.status = relationshipType.pending.rawValue
        batch.setData(relationshipObject.asDictionary()!, forDocument: selfRef)
        
        
        batch.commit()
    }
    public func cancelFriendRequestAndUnfriend(targetUsername:String){
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let relationshipString = IdManager.shared.generateRelationshipIdFor(targetUsername: targetUsername)
        else {return}
        
        let targetRef = database.collection("users").document(targetUsername).collection("relationship").document(username)
        let selfRef = database.collection("users").document(username).collection("relationship").document(targetUsername)
        
        let batch  = database.batch()
        
        batch.deleteDocument(targetRef)
        batch.deleteDocument(selfRef)
        
        batch.commit()
        
    }
    
    public func acceptFriendRequest(targetUsername:String) {
        // status set to friend
        
        guard let username = UserDefaults.standard.string(forKey: "username")
        else {return}
        
        let targetRef = database.collection("users").document(targetUsername).collection("relationship").document(username)
        let selfRef = database.collection("users").document(username).collection("relationship").document(targetUsername)
        
        
        let batch  = database.batch()
        
        batch.updateData(["status" : relationshipType.friend.rawValue], forDocument: selfRef)
        batch.updateData(["status" : relationshipType.friend.rawValue], forDocument: targetRef)
        
        batch.commit()
        
    }
    
}
