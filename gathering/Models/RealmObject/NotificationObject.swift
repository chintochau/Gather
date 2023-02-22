//
//  RequestObject.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import UIKit
import RealmSwift

enum NotificationType:Int {
    case friendRequest = 0
    case eventInvite = 1
    
}

class NotificationObject: Object, Codable {

    @Persisted var from:String
    @Persisted var profileUrlString:String?
    @Persisted var to:String
    @Persisted var eventid:String?
    @Persisted var eventUrlString:String?
    
}
