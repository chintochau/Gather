//
//  AuthManager.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-13.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()

    private init (){}

    let auth = Auth.auth()
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    
    // MARK: - Login/Signup
    public func signUp(username:String,email:String, password:String, completion: @escaping (User?) -> Void) {
        
        let newUser = User(username: username, email: email, name: nil, profileUrlString: nil, hobbies: [nil], gender: "")
        
        
        DatabaseManager.shared.findUserWithUsername(with: username) { user in
            guard user == nil else {
                completion(nil)
                return}
            print(1)
            self.auth.createUser(withEmail: email, password: password) { result, error in
                guard error == nil, result != nil else {
                    completion(nil)
                    return
                }
                print(2)
                DatabaseManager.shared.createUserProfile(newUser: newUser) { success in
                    guard success else {
                        print(3)
                        completion(nil)
                        return
                    }
                    completion(newUser)
                }
            }
        }
    }
    
    public func logIn(email:String, password:String, completion: @escaping (User?) -> Void){
        
        auth.signIn(withEmail: email, password: password) { result, error in
            guard error == nil, result != nil else {
                completion(nil)
                return}
            
            DatabaseManager.shared.findUserWithEmail(with: email) { user in
                guard let user = user else {
                    completion(nil)
                    return}
                
                UserDefaultsManager.shared.updateUserProfile(with: user)
                completion(user)
            }
        }
    }

    public func signOut(completion: @escaping (Bool) -> Void){
        do {
            try auth.signOut()
            completion(true)
        }catch{
            print(error)
            completion(false)
        }
    }

}
