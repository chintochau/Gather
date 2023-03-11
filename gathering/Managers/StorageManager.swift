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
    
    let storage:StorageReference =  {
        let storage = Storage.storage()
//        storage.useEmulator(withHost: "localhost", port: 9199)
        return storage.reference()
    }()
    
    // MARK: - Upload Image
    public func uploadEventImage(id:String,data:[Data?], completion: @escaping ([String]) -> Void){
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
    
    
    public func uploadprofileImage(image:UIImage, completion: @escaping (String?) -> Void){
        
        guard let image = image.sd_resizedImage(with: CGSize(width: 1024, height: 1024), scaleMode: .aspectFill),
              let data = image.jpegData(compressionQuality: 0.5),
              let username = UserDefaults.standard.string(forKey: "username")
        else {return}
        
        let ref = storage.child("users/\(username)/profileImage.jpg")
        
        ref.putData(data) { _, error in
            
            guard error == nil else {
                completion(nil)
                return
            }
            ref.downloadURL { url, error in
                guard let urlString = url?.absoluteString else {
                    completion(nil)
                    return}
                
                completion(urlString)
                
            }
            
        }
    }
    
}
