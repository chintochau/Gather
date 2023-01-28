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
    public func uploadImage(id:String,data:[Data?], completion: @escaping ([String]) -> Void){
        var downloadUrls = [String]()
        let group = DispatchGroup()
        for (index, data) in data.enumerated() {
            guard let data = data else {
                return
            }
            let ref = storage.child("events/\(id)/\(id)_\(index).jpg")
            // Enter dispatch queue 1, total 3 at most
            group.enter()
            ref.putData(data) { _, error in
                guard error == nil else {
                    return
                }
                ref.downloadURL { url, error in
                    guard let urlString = url?.absoluteString else {return}
                    
                    defer{
                        group.leave()
                    }
                    
                    downloadUrls.append(urlString)
                }
                
            }
        }
        group.notify(queue: .main) {
            completion(downloadUrls)
        }
    }
}
