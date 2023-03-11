//
//  FunctionsManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-03-10.
//

import Foundation
import FirebaseFunctions


struct FunctionsManager {
    static let shared = FunctionsManager()
    
    
    let functions:Functions = {
        let functions = Functions.functions()
//        functions.useEmulator(withHost: "localhost", port: 5001)
        return functions
    }()
    
    public func registerEvent(event:Event, completion:@escaping (Bool,_ message:String) -> Void){
        guard let user = DefaultsManager.shared.getCurrentUser(),
              let userData = Participant(with: user).asDictionary(),
              let referencePath = event.referencePath
        else {return}
        
        // Call the joinEvent function with the user and event IDs
        let data: [String: Any] = [
            "user": userData,
            "eventId": event.id,
            "referencePath": referencePath,
        ]
        
        functions.httpsCallable("joinEvent").call(data) { (result, error) in
            if let error = error {
                print("Error joining event: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            guard let data = result?.data as? [String: Any] else {
                print("Unexpected response from server")
                completion(false, "Unexpedted response from server")
                return
            }
            let success = data["success"] as? Bool ?? false
            let message = data["message"] as? String ?? ""
            if success {
                print("Successfully joined event")
                completion(true, "Successfully joined event")
            } else {
                print("Failed to join event: \(message)")
                completion(false, "Failed to join event: \(message)")
            }
        }
        
    }
    
}

