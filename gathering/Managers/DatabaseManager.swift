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
    
    public func createEvent (with event:Event, completion: @escaping (Event) -> Void) {
        var finalEvent:Event = event
        
        database.runTransaction {[weak self] transaction, error in
            guard let eventRef = self?.database.collection("events").document(event.endDate.getYearWeek()),
                  let user = DefaultsManager.shared.getCurrentUser(),
                  let userEventRef = self?.database.collection("users").document(user.username).collection("events").document(event.startDate.getYearMonth())
            else {return}
            
            finalEvent.referencePath = eventRef.path
            finalEvent.referencePathForUser = event.endDate.getYearMonth()
            
            guard let eventData = finalEvent.asDictionary(),
                  let userEventData = finalEvent.toUserEvent().asDictionary() else {return}
            
            transaction.setData([
                event.id : eventData,
                "_startTimestamp":event.endDate.firstDayOfWeekTimestamp(),
                "_endTimestamp":event.endDate.lastDayOfWeekTimestamp() - 1
            ], forDocument: eventRef,merge: true)
            transaction.setData([
                "_monthStartTimestamp": event.endDate.getMonthInDate().timeIntervalSince1970,
                "_monthEndTimestamp": event.endDate.startOfNextMonth().timeIntervalSince1970 - 1,
                event.id: userEventData
            ], forDocument: userEventRef,merge: true)
            
            return nil
            
        } completion: { (_,error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                completion(finalEvent)
                print("Transaction successfully committed!")
            }
        }
        
    }
    
    // MARK: - Read Event
    
    public func fetchEvents(numberOfResults: Int,startDate:Date = Date.todayAtMidnight(), exclude excludeEvents: [Event] = [], completion: @escaping ([Event]?) -> Void) {
        print("start fetching from date: \(startDate)")
        let ref = database.collection("events")
            .order(by: "_endTimestamp", descending: false)
            .whereField("_endTimestamp", isGreaterThan: startDate.timeIntervalSince1970)
            .limit(to: 1)
        
        
        
        ref.getDocuments { snapshot, error in
            guard let documentData = snapshot?.documents.first?.data() else {
                print("no more event fetched")
                completion(nil)
                return
            }
            
            var events = [Event]()
            let _ = documentData["_startTimestamp"] as? Double ?? 0.0
            let endTimestamp = documentData["_endTimestamp"] as? Double ?? 0.0
            
            for (key, value) in documentData {
                if key != "_startTimestamp" && key != "_endTimestamp" {
                    if let event = Event(with: value as! [String : Any]) {
                        events.append(event)
                    }
                }
            }
            
            if events.count >= numberOfResults {
                print("Events >= 7 :  events fetched: \(events.count)")
                completion(events)
            }else {
                print("Events < 7 : events fetched: \(events.count)")
                self.fetchEvents(numberOfResults: numberOfResults - events.count,startDate: Date(timeIntervalSince1970: endTimestamp)) { extraEvents in
                    guard let extraEvents = extraEvents else {
                        completion(events)
                        return}
                    events.append(contentsOf: extraEvents)
                    completion(events)
                    
                }
            }
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
    
    public func fetchSingleEvent(event:Event, completion:@escaping(Event?) -> Void ){
        
        guard let refPath = event.referencePath else {
            completion(nil)
            return
        }
        let ref = database.document(refPath)
        ref.getDocument { snapshot, error in
            guard let documentData = snapshot?.data() else {return}
            let event = Event(with: documentData[event.id] as! [String : Any])
            completion(event)
        }
    }
    public func fetchSingleEvent(eventID:String, eventReferencePath:String?, completion:@escaping(Event?) -> Void ){
        
        guard let refPath = eventReferencePath else {
            completion(nil)
            return
        }
        let ref = database.document(refPath)
        ref.getDocument { snapshot, error in
            guard let documentData = snapshot?.data(),
            let data = documentData[eventID] as? [String: Any] else {
                completion(nil)
                return
            }
            let event = Event(with: data)
            completion(event)
        }
    }
    
    public func listenForEventChanges(eventId: String, completion: @escaping (Event?, Error?) -> Void) -> ListenerRegistration {
        
        let db = Firestore.firestore()
        let eventRef = db.collection("events").document(eventId)
        
        let listener = eventRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = snapshot?.data(),
                  let event = Event(with: data) else {
                completion(nil, nil)
                return
            }
            
            completion(event, nil)
        }
        
        return listener
    }
    
    

    
    // MARK: - UpdateEvents
    
    public func registerEvent(participant: User,eventID:String,event:Event,completion:@escaping (Bool) -> Void){
        
        guard let participant = Participant(with: participant).asDictionary(),
              let username = UserDefaults.standard.string(forKey: "username"),
              let referencePath = event.referencePath,
              let referencePathForUser = event.referencePathForUser
        else {
            completion(false)
            print("Failed to register event")
            return}
        
        database.runTransaction {[weak self] transaction, error in
            
            
            guard let eventRef = self?.database.document(referencePath),
                  let userEventRef = self?.database.document("users/\(username)/events/\(referencePathForUser)/"),
                  let notificationRef = self?.database.document("notifications/\(event.organisers.first?.username ?? "admin")/\(Date().getYearWeek())/\(Date().getYearWeek())")
            else {return}
            
            // Update event reference
            transaction.setData(
                [event.id:[
                    "participants":[
                        username:participant
                    ]]],
                forDocument: eventRef,merge: true)
            
            // Update user reference
            transaction.setData([
                "_monthStartTimestamp": event.endDate.getMonthInDate().timeIntervalSince1970,
                "_monthEndTimestamp": event.endDate.startOfNextMonth().timeIntervalSince1970 - 1,
                event.id: event.toUserEvent().asDictionary()!
            ], forDocument: userEventRef,merge: true)
            
            if username != event.organisers.first?.username {
                let notification = Notification(
                    type: .eventJoin,
                    sender: username,
                    friendRequest: nil,
                    event: event.toUserEvent())
                if let notificationData = notification.asDictionary() {
                    transaction.setData([
                        "fcmToken":event.ownerFcmToken,
                        notification.id : notificationData
                    ], forDocument: notificationRef,merge: true)
                }
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
        
    }
    
    // MARK: - Delete Events
    public func unregisterEvent(event:Event, completion:@escaping (Bool) -> Void) {
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
              let referencePath = event.referencePath,
              let referencePathForUser = event.referencePathForUser
        else {
            completion(false)
            print("Failed to retrive username")
            return}
        
        database.runTransaction {[weak self] transaction, error in
            
            guard let eventRef = self?.database.document(referencePath),
                  let userEventRef = self?.database.document("users/\(username)/events/\(referencePathForUser)")
            else {return}
            
            // Update event reference
            transaction.setData([
                event.id: [
                    "participants": [
                        username: FieldValue.delete()
                    ]
                ]
            ],forDocument: eventRef,merge: true)
            
            // Update user reference
            transaction.setData([
                event.id: FieldValue.delete()
            ], forDocument: userEventRef,merge: true)
            
            return nil
            
        } completion: { (_,error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                completion(true)
                print("Event Unregistered!")
            }
        }
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
        
        guard let username = UserDefaults.standard.string(forKey: "username")
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
