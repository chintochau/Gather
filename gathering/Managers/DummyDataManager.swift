//
//  DummyDataManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-22.
//

import UIKit
import Firebase
import FirebaseFirestore

struct DummyDataManager {
    static let shared = DummyDataManager()
    
    
    func generateDummyEvents() {
        let db = Firestore.firestore()
        
        for i in 1...50 {
            // Generate a unique ID for the event
            let eventId = UUID().uuidString
            
            // Generate a random introduction for the event
            let introduction = "Join us for the \(hobbyType.allCases.randomElement()!.rawValue) event of the year! This is a great opportunity to meet new people, have fun, and enjoy some amazing activities. Our expert organizers have put together a fantastic lineup of events that will keep you engaged and entertained all day long. Whether you're a seasoned pro or a beginner, there's something for everyone at this event. So come on out and join us for a day of fun and excitement!"

            let user = User(
                username: "jjchau - \(i)",
                email: "jj@jj.com",
                name: "JasonChau\(i)",
                profileUrlString: i%4 == 0 ? "https://picsum.photos/\(i%5)00/300" : nil,
                gender: i%5 == 0 ? "male" : "female")
            
            let participant = Participant(with: user)
            
            // Generate dummy data for the event
            let event = Event(
                id: eventId,
                emojiTitle: nil,
                title: "Event \(i)",
                organisers: [user],
                imageUrlString: i%4 == 0 ? ["https://picsum.photos/400/\(i%4)00"] : [],
                price: Double(i),
                startDateTimestamp: Date(timeIntervalSinceNow: TimeInterval(i * 86400)).timeIntervalSince1970,
                endDateTimestamp: Date(timeIntervalSinceNow: TimeInterval((i+1) * 86400)).timeIntervalSince1970,
                location: Location(name: "Location \(i)", address: "Address \(i)", latitude: Double(i), longitude: Double(i+1)),
                tag: [],
                introduction: introduction,
                additionalDetail: nil,
                refundPolicy: "",
                participants: [user.username:participant],
                headcount: Headcount(isGenderSpecific: i%3 == 0 ? true : false, min: 0, max: 100, mMin: 0, mMax: 50, fMin: 0, fMax: 50),
                ownerFcmToken: nil
            )
            
            // Convert the event to a dictionary
            guard let eventData = event.asDictionary() else {
                print("Error converting event \(eventId) to dictionary")
                return
            }
            
            // Upload the event data to Firestore
            db.collection("events").document(eventId).setData(eventData) { (error) in
                if let error = error {
                    print("Error writing event \(eventId) to Firestore: \(error.localizedDescription)")
                    return
                }
                print("Successfully wrote event \(eventId) to Firestore")
            }
        }
    }


    
}
