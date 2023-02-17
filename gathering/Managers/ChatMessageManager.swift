//
//  ChatMessageManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-17.
//

import Foundation
import PubNub

struct ChatMessageManager {
    static let shared = ChatMessageManager()
    
    let pubNub:PubNub = {
        let config = PubNubConfiguration(
            publishKey: "pub-c-1e30f6e1-a29f-4a4d-ac62-01bf0a141150",
            subscribeKey: "sub-c-bb25b314-3fc0-48d7-ae4a-5bd2ca17abf2",
            userId: "myUniqueUserId")
        return PubNub(configuration: config)
    }()
    
    func setupPubNub() {
        
        PubNub.log.levels = [.all]
        PubNub.log.writers = [ConsoleLogWriter(), FileLogWriter()]
        let config = PubNubConfiguration(
            publishKey: "pub-c-1e30f6e1-a29f-4a4d-ac62-01bf0a141150",
            subscribeKey: "sub-c-bb25b314-3fc0-48d7-ae4a-5bd2ca17abf2",
            userId: "myUniqueUserId")
        let _ = PubNub(configuration: config)
        
    }
    
}
