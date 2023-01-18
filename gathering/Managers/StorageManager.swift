//
//  StorageManager.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-13.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    let storage = Storage.storage().reference()
    
    // MARK: - Upload Image
    public func uploadImage(id:String,data:Data?, completion: @escaping (URL?) -> Void){
        guard let data = data else {
            completion(nil)
            return
        }
        let ref = storage.child("events/\(id)/\(id).jpg")
        ref.putData(data) { _, error in
            guard error == nil else {
                completion(nil)
                return
            }
            ref.downloadURL { url, error in
                completion(url)
            }
        }
    }
    
    
}
