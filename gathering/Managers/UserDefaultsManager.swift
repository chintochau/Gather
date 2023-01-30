//
//  UserDefaultsManager.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-28.
//

import Foundation

enum UserDefaultsType:String,CaseIterable {
    case username = "username"
    case email = "email"
    case profileUrlString = "profileUrlString"
    case gender = "gender"
    case name = "name"
    case user = "user"
}


final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    public func updateUserProfile(with user:User){
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.profileUrlString, forKey: "profileUrlString")
        UserDefaults.standard.set(user.gender, forKey: "gender")
        UserDefaults.standard.set(user.name, forKey: "name")
        if let user = user.asDictionary() {
            UserDefaults.standard.set(user, forKey: "user")
        }
    }
    
    public func resetUserProfile(){
        UserDefaults.standard.set(nil, forKey: "username")
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "profileUrlString")
        UserDefaults.standard.set(nil, forKey: "gender")
        UserDefaults.standard.set(nil, forKey: "name")
        UserDefaults.standard.set(nil, forKey: "user")
    }
    
    public func printAllUserdefaults(){
        UserDefaultsType.allCases.forEach({
            switch $0 {
            case .user:
                    print(getCurrentUser() ?? "Not Set" )
            default:
                print("\($0.rawValue): \(UserDefaults.standard.string(forKey: $0.rawValue) ?? "Not Set")")
            }
        })
    }
    
    public func getCurrentUser() -> User? {
        guard let user = UserDefaults.standard.object(forKey: "user") as? [String : Any] else {return nil}
        return User(with: user)
    }
    
    
}


