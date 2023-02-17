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
    
    // MARK: - create Event
    public func createEvent (with event:Event,participants:[Participant], completion: @escaping (Bool) -> Void) {
        
        database.runTransaction {[weak self] transaction, error in
            
            guard let eventRef = self?.database.collection("events").document(event.id),
                  let eventData = event.asDictionary(),
                  let user = DefaultsManager.shared.getCurrentUser(),
                  let userEventRef = self?.database.collection("users").document(user.username).collection("events").document(event.id)
            else {return}
            
            transaction.setData(eventData, forDocument: eventRef)
            transaction.setData(["id":event.id,"startTimestamp":Double.todayAtMidnightTimestamp()], forDocument: userEventRef)
            
            for participant in participants {
                let ref = eventRef.collection("participants").document(participant.username ?? participant.name)
                guard let participantData = participant.asDictionary() else {return}
                transaction.setData(participantData, forDocument: ref)
            }
            return nil
        } completion: { (_,error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                completion(true)
                print("Transaction successfully committed!")
            }
        }

        
//        guard let data = event.asDictionary() else {return}
//
//        ref.setData(data) {[weak self] error in
//
//            completion(error == nil)
//            guard error == nil,
//            let user = UserDefaultsManager.shared.getCurrentUser() else {return}
//
//            self?.registerEvent(participant: user, eventID:event.id) { success in
//                completion(success)
//            }
//
//        }
    }
    
    // MARK: - Fetch Event
    public func fetchAllEvents(exclude excludeEvents:[Event] = [],completion: @escaping ([Event]?) -> Void) {
        
        let excludedEventIDs = excludeEvents.compactMap({$0.id})
        
        let ref = database.collection("events")
        let query = ref.whereField("startTimestamp", isGreaterThanOrEqualTo: Double.todayAtMidnightTimestamp()).limit(to: 30)
        
        
        query.getDocuments { snapshot, error in
            
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
    
    public func fetchUserEvents(with userID:String,todayAndAfter:Bool = true, completion:@escaping ([Event]?) -> Void) {
        
        let ref = database.collection("users").document(userID).collection("events")
        
        
        ref.whereField("startTimestamp", isGreaterThanOrEqualTo: todayAndAfter ? Double.todayAtMidnightTimestamp() : 0.0 ).limit(to: 9).getDocuments {[weak self] snapshot, error in
            guard error == nil else {return}
            guard let array = snapshot?.documents.compactMap({$0.data()["id"]}) as? [String],
            !array.isEmpty else {
                completion([])
                return
            }
            
            
            let eventsRef = self?.database.collection("events")
            
            eventsRef?.whereField("id", in: array).getDocuments(completion: { snapshot, error in
                guard error == nil else {return}
                let events = snapshot?.documents.compactMap({
                    
                    
                    Event(with:$0.data())
                })
                
                completion(events?.sorted(by: { lhs, rhs in
                    return lhs.startTimestamp < rhs.startTimestamp
                }))
            })
            
            
        }
        
    }
    
    // MARK: - JoinEvent
    
    public func registerEvent(participant: User,eventID:String,eventStarttimestamp:Double,completion:@escaping (Bool) -> Void){
        
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
    
}
