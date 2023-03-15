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
    
    let database:Firestore = {
        let database = Firestore.firestore()
//        database.useEmulator(withHost: "localhost", port: 8080)
        
        return database
    }()
    
    
    
    // MARK: - User Profile
    /// to create user profile when user first login the app
    public func createUserProfile(newUser:User, completion: @escaping (Bool) -> Void) {
        
        let ref = database.collection("users").document(newUser.username)
        
        guard let data = newUser.asDictionary() else {
            completion(false)
            return
        }
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
    
    
    // Reference should be start and end of day in UTC time, each document containts events on that day
    // event reference should be events/{yearDay} example: "events/2023115"
    let startDateReference:String = "_dayStartTimestamp"
    let endDateReference:String = "_dayEndTimestamp"
    let monthStartDateReference:String = "_monthStartTimestamp"
    let monthEndDateReference:String = "_monthEndTimestamp"
    
    
    public func createEvent (with event:Event, completion: @escaping (Event) -> Void) {
        var finalEvent:Event = event
        
        let startDateReference:String = startDateReference
        let endDateReference:String = endDateReference
        let monthStartDateReference:String = monthStartDateReference
        let monthEndDateReference:String = monthEndDateReference
        
        // events/202310 (year day)
        let eventReferncePath = event.endDate.yearDayStringUTC()
        // 202310 (year month)
        let userEventReferencePath = event.endDate.yearMonthStringUTC()
        
        
        database.runTransaction {[weak self] transaction, error in
            
            guard let eventRef = self?.database.collection("events").document(eventReferncePath),
                  let user = DefaultsManager.shared.getCurrentUser(),
                  let userEventRef = self?.database.collection("users").document(user.username).collection("events").document(userEventReferencePath),
                  let chatroomRef = self?.database.collection("eventChatrooms").document(event.id)
            else {return}
            
            // generate referencePath for event
            finalEvent.referencePath = eventRef.path
            finalEvent.referencePathForUser = userEventReferencePath
            
            guard let eventData = finalEvent.asDictionary(),
                  let userEventData = finalEvent.toUserEvent().asDictionary() else {return}
            
            // collection: events/
            transaction.setData([
                event.id : eventData,
                startDateReference:event.endDate.startOfDayTimestampUTC(),
                endDateReference:event.endDate.adding(days: 1).startOfDayTimestampUTC() - 1
            ], forDocument: eventRef,merge: true)
            
            // collection: users/{username}/events/
            transaction.setData([
                monthStartDateReference: event.endDate.startOfMonthTimestampUTC(),
                monthEndDateReference: event.endDate.startOfNextMonthTimestampUTC() - 1,
                event.id: userEventData
            ], forDocument: userEventRef,merge: true)
            
            
            transaction.setData([
                "participants": [user.username: user.fcmToken]
            ], forDocument: chatroomRef, merge: true)
            
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
    
    public func fetchEvents(numberOfResults: Int,startDate:Date = Date().startOfDayTimestampUTC().toDate(), exclude excludeEvents: [Event] = [], completion: @escaping ([Event]?) -> Void) {
        
        let startDateReference:String = startDateReference
        let endDateReference:String = endDateReference
        
        print("start fetching from date: \(startDate)")
        let ref = database.collection("events")
            .order(by: endDateReference, descending: false)
            .whereField(endDateReference, isGreaterThan: startDate.timeIntervalSince1970)
            .limit(to: 1)
        
        
        
        ref.getDocuments { snapshot, error in
            guard let documentData = snapshot?.documents.first?.data() else {
                print("no more event fetched")
                completion(nil)
                return
            }
            
            
            // Get the size of the data
            let sizeInBytes = documentData.count
            print("Size of the document in bytes: \(sizeInBytes)")
            
            var events = [Event]()
            let _ = documentData[startDateReference] as? Double ?? 0.0
            let endTimestamp = documentData[endDateReference] as? Double ?? 0.0
            
            for (key, value) in documentData {
                if key != startDateReference && key != endDateReference {
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
            guard let documentData = snapshot?.data() ,
            let data = documentData[event.id] as? [String: Any] else {
                completion(nil)
                return}
            let event = Event(with: data)
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
    
    // should be stop using already
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
    
    public func getUserEvents(username:String, startDate:Date = Date.startOfTodayLocalTime(),numberOfResults:Int = 7, completion:@escaping ([UserEvent]?) -> Void){
        
        let monthStartDateReference:String = monthStartDateReference
        let monthEndDateReference:String = monthEndDateReference
        
        
        print("start fetching userEvnets from date: \(startDate)")
        
        let ref = database.collection("users/\(username)/events")
            .order(by: monthEndDateReference, descending: false)
            .whereField(monthEndDateReference, isGreaterThan: startDate.timeIntervalSince1970)
            .limit(to: 1)

        
        
        ref.getDocuments { snapshot, error in
            guard let documentData = snapshot?.documents.first?.data() else {
                print("no more event fetched")
                completion(nil)
                return
            }
            
            var events = [UserEvent]()
            let _ = documentData[monthStartDateReference] as? Double ?? 0.0
            let endTimestamp = documentData[monthEndDateReference] as? Double ?? 0.0
            
            for (key, value) in documentData {
                
                if key != monthStartDateReference && key != monthEndDateReference {
                    if let value = value as? [String : Any] {
                        if let event = UserEvent(with: value) {
                            events.append(event)
                        }
                    }
                }
            }
            
            if events.count >= numberOfResults {
                print("Events >= 7 :  events fetched: \(events.count)")
                completion(events)
            }else {
                print("Events < 7 : events fetched: \(events.count)")
                self.getUserEvents(username: username, startDate: Date(timeIntervalSince1970: endTimestamp), numberOfResults: numberOfResults - events.count) { extraEvents in
                    guard let extraEvents = extraEvents else {
                        completion(events)
                        return}
                    events.append(contentsOf: extraEvents)
                    completion(events)
                    
                }
            }
        }
        
    }
    
    

    
    // MARK: - UpdateEvents
    ///confirm form event and send notification to all participants
    public func confirmFormEvent(eventName:String, eventID:String,eventReferencePath:String, completion:@escaping (Bool) -> Void){
        
        guard let username = UserDefaults.standard.string(forKey: "username"),
        let name = UserDefaults.standard.string(forKey: "name") else {
            completion(false)
            return}
        
         let eventRef = database.document(eventReferencePath)
        
        eventRef.setData([eventID:["eventStatus": EventStatus.confirmed.rawValue]], merge: true) { error in
            
            let message = ChatRoomMessage(
                eventName: eventName,
                eventId: eventID,
                senderUsername: username,
                senderName: name,
                message: "\(eventName)成團了！",
                referencePath: eventReferencePath)
            
            FunctionsManager.shared.sendMassMessage(message: message)
            
            completion(error == nil)
        }
    }
    
    public func registerEventFromClient(participant: User,eventID:String,event:Event,completion:@escaping (Bool) -> Void){
        let monthStartDateReference:String = monthStartDateReference
        let monthEndDateReference:String = monthEndDateReference
        
        guard let participant = Participant(with: participant).asDictionary(),
              let username = UserDefaults.standard.string(forKey: "username"),
              let referencePath = event.referencePath,
              let referencePathForUser = event.referencePathForUser
        else {
            completion(false)
            print("Failed to register event")
            return}
        
        database.runTransaction {[weak self] transaction, error in
            
            guard let user = DefaultsManager.shared.getCurrentUser(),
                let eventRef = self?.database.document(referencePath),
                  let userEventRef = self?.database.document("users/\(username)/events/\(referencePathForUser)/"),
                  let notificationRef = self?.database.document("notifications/\(event.organisers.first?.username ?? "admin")/\(Date().yearWeekStringLocalTime())/\(Date().yearWeekStringLocalTime())")
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
                monthStartDateReference: event.endDate.startOfTheSameMonthLocalTime().timeIntervalSince1970,
                monthEndDateReference: event.endDate.startOfTheNextMonthLocalTime().timeIntervalSince1970 - 1,
                event.id: event.toUserEvent().asDictionary()!
            ], forDocument: userEventRef,merge: true)
            
            if username != event.organisers.first?.username {
                let notification = GANotification(
                    type: .eventJoin,
                    sentUser: user.toSentUser(),
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
    public func deleteEvent(eventID:String, eventRef:String, completion:@escaping (Bool) -> Void){
        
        let ref = database.document(eventRef)
        
        ref.setData([eventID:FieldValue.delete()], merge: true) { error in
            guard error == nil else {return}
            
            StorageManager.shared.deleteImages(id: eventID) { Bool in
                completion(error == nil)
            }
            
            
        }
    }
    
    
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
        
        guard let user = DefaultsManager.shared.getCurrentUser(),
              let relationshipString = IdManager.shared.generateRelationshipIdFor(targetUsername: targetUsername)
        else {return}
        
        let username = user.username
        
        let targetRef = database.collection("users").document(targetUsername).collection("relationship").document(username)
        let selfRef = database.collection("users").document(username).collection("relationship").document(targetUsername)
        let targetNotificationRef = database.collection("notifications/\(targetUsername)/notifications").document(Date().yearMonthStringUTC())
        
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
        
        // wrtie to target notificaion
        let notification = GANotification(id: IdManager.shared.createFriendRequestID(targetUsername: targetUsername) ,type: .friendRequest, sentUser: user.toSentUser(), event: nil)
        if let notificationData = notification.asDictionary() {
            batch.setData([
                GANotification.startDateString: Date().startOfMonthTimestampUTC(),
                GANotification.endDateString: Date().startOfNextMonthTimestampUTC()-1,
                notification.id: notificationData
            ], forDocument: targetNotificationRef,merge: true)
        }
        
        batch.commit()
    }
    
    /// handle all relationships
    public func updateFriendRequests(targetUsername:String, status:Int ){
        
        var selfRelationShipStatus:Int = 0
        var targetRelationShipStatus:Int = 0
        
        switch status {
        case relationshipType.friend.rawValue:
            selfRelationShipStatus = status
            targetRelationShipStatus = status
        case relationshipType.noRelation.rawValue:
            selfRelationShipStatus = status
            targetRelationShipStatus = status
        case relationshipType.pending.rawValue:
            selfRelationShipStatus = status
            targetRelationShipStatus = relationshipType.received.rawValue
        case relationshipType.received.rawValue:
            selfRelationShipStatus = relationshipType.received.rawValue
            targetRelationShipStatus = status
        case relationshipType.blocked.rawValue:
            selfRelationShipStatus = status
            targetRelationShipStatus = status
        default:
            print("Realtionship Type Not handled")
        }
        
        
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
        relationshipObject.status = targetRelationShipStatus
        batch.setData(relationshipObject.asDictionary()!, forDocument: targetRef)
        
        // write to self
        relationshipObject.targetUsername = targetUsername
        relationshipObject.selfUsername = username
        relationshipObject.status = selfRelationShipStatus
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
    
    
    // MARK: - Comments
    /// Post comment, also notify the owner
    public func postComments(event:Event, message:String,completion:@escaping (Bool) -> Void){

        
        guard let referencePath = event.referencePath,
              let user = DefaultsManager.shared.getCurrentUser()
        else {return}
        
        let comment = Comment(sender: user.name ?? user.username, message: message, timestamp: Date().timeIntervalSince1970)
        let ref = database.document(referencePath)
        
        
        if let commentData = comment.asDictionary() {
            ref.setData([
                event.id: [
                    "comments":FieldValue.arrayUnion([commentData])
                ]
            ],merge: true) { error in
                guard error == nil else {
                    completion(error == nil)
                    return
                }
                
                FunctionsManager.shared.sendMassMessage(
                    message: .init(eventName: event.title, eventId: event.id, senderUsername: user.username, senderName: "\(user.name ?? user.username)留言", message: message, referencePath: referencePath))
                completion(error == nil)
                
            }
        }
    }

    
    // MARK: - FcmToken
    public func updateFcmTokenToServer(){
        
        database.runTransaction({ [weak self] (transaction, errorPointer) -> Any? in
            
            guard let db = self?.database,
            let user = DefaultsManager.shared.getCurrentUser(),
                let fcmToken = CustomNotificationManager.fcmToken else {return}
            
            let thisMonthDateString = Date().yearMonthStringUTC()
            let nextMonthDateString = Date().startOfNextMonthTimestampUTC().toDate().yearMonthStringUTC()
            
            let docRef1 = db.document("notifications/\(user.username)/notifications/\(thisMonthDateString)")
            let docRef2 = db.document("notifications/\(user.username)/notifications/\(nextMonthDateString)")
            let docRef3 = db.document("users/\(user.username)")
            
            
            transaction.setData([
                "fcmToken": fcmToken
            ], forDocument: docRef1, merge: true)
            transaction.setData([
                "fcmToken": fcmToken
            ], forDocument: docRef2, merge: true)
            transaction.setData(["fcmToken": fcmToken], forDocument: docRef3, merge: true)
            
            return nil
            
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error.localizedDescription)")
            } else {
                print("Transaction successful!")
            }
        }
        
        
    }
    
}
