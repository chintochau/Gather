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
        
        for i in 1...30 {
            // Generate a unique ID for the event
            let eventId = UUID().uuidString
            
            let randomValue = Int.random(in: 0...4)
            let emoji: String?
            
            switch randomValue {
            case 0:
                emoji = "😀"
            case 1:
                emoji = "🤔"
            case 2:
                emoji = "😍"
            case 3:
                emoji = "😈"
            case 4:
                emoji = "🤡"
            default:
                emoji = nil
            }
            
            // Generate a random introduction for the event
            let introduction = "Join us for the \(hobbyType.allCases.randomElement()!.rawValue) event of the year! This is a great opportunity to meet new people, have fun, and enjoy some amazing activities. Our expert organizers have put together a fantastic lineup of events that will keep you engaged and entertained all day long. Whether you're a seasoned pro or a beginner, there's something for everyone at this event. So come on out and join us for a day of fun and excitement! ".repeating(5)
            
            
            
            var organisers = [User]()
            var participants = [String: Participant]()
            var imageUrlStrings = [String]()
            
            for j in 1...100 {
                // Generate a user for the participant
                let user = User(
                    username: "participant\(j)_event\(i)",
                    email: "participant\(j)_event\(i)@example.com",
                    name: "Participant \(j)",
                    profileUrlString: nil,
                    gender: j % 2 == 0 ? "male" : "female"
                )
                
                // Create a participant for the user
                let participant = Participant(with: user)
                
                // Add the user to the organisers list for the first event
                if j == 1 {
                    organisers.append(user)
                }
                
                // Add the participant to the participants list
                participants[user.username] = participant
            }
            
            // Generate an image URL for the event
            imageUrlStrings.append("https://picsum.photos/400/300?random=\(i)")
            
            // Generate dummy data for the event
            let event = Event(
                id: eventId,
                emojiTitle: emoji,
                title: "Event \(i)",
                organisers: organisers,
                imageUrlString: imageUrlStrings,
                price: Double(i),
                startDateTimestamp: Date(timeIntervalSinceNow: TimeInterval(i * 86400)).timeIntervalSince1970,
                endDateTimestamp: Date(timeIntervalSinceNow: TimeInterval((i+1) * 86400/10)).timeIntervalSince1970,
                location: Location(name: "Location \(i)", address: "Address \(i)", latitude: Double(i), longitude: Double(i+1)),
                presetTags: [],
                introduction: introduction,
                additionalDetail: nil,
                refundPolicy: "",
                participants: participants,
                headcount: Headcount(isGenderSpecific: i%3 == 0 ? true : false, min: 0, max: 100, mMin: 0, mMax: 50, fMin: 0, fMax: 50),
                ownerFcmToken: UUID().uuidString,
                eventStatus: i%3 == 0 ? .grouping : .confirmed
            )
            
            
            
            // Upload the event data to Firestore
            DatabaseManager.shared.createEvent(with: event) { success in
                print("Event created with event ID: \(event.id)")
            }
        }
    }


    
}

extension String {
    func repeating(_ count: Int) -> String {
        var result = ""
        for _ in 0..<count {
            result += self
        }
        return result
    }
}
