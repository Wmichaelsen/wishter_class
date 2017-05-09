//
//  FirebaseStorageOperations.swift
//  wishter
//
//  Created by Wilhelm Michaelsen on 2017-04-14.
//  Copyright © 2017 Wilhelm Michaelsen. All rights reserved.
//

import Foundation
import Firebase

class FirebaseStorageOperations {
    
    let storage = FIRStorage.storage()
    let ref: FIRStorageReference
    
    init(st: String) {
        self.ref = storage.reference()
    }
    
    func uploadToPath(path: String, data: NSData) -> Void {
    
        let storageRef = ref.child(path)

        let usersRef = storageRef.child("userWishes")
        
        usersRef.put(data as Data, metadata: nil) {
            (metadata, error) in
            print("\n\nMeta: \(metadata)\n\nError: \(error)\n\n")
        }
    }
    
    func downloadFromPath(path: String, completion: @escaping (NSData?) -> Void) {
        
        let storageRef = ref.child(path)
        
        storageRef.data(withMaxSize: 1*5024*5024, completion: {
            (data, error) in
            completion(data as NSData?)
        })
    }
}
