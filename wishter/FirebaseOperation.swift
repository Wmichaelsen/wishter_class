//
//  FirebaseOperation.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-06-14.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

//MARK: -
//MARK: Description

//  Class performs all communication with Firebase database
//  ALL database arrends should go through here

//MARK: -

import Foundation
import Firebase
import FirebaseAuth

class FirebaseOperation {

    let refURL: String
    
    init(url: String) {
        refURL = url
    }
    
    func unAuth() {
        try! FIRAuth.auth()!.signOut()
    }
    
    func authenticateWithProvider(_ provider: String, token: String, credential: FIRAuthCredential, withCompletion: @escaping (_ authData: FIRUser?, _ error: Error?) -> Void) {
        
        FIRAuth.auth()?.signIn(with: credential) {
            (user, error) in
            withCompletion(user, error)
            
        }

//        FIRAuth.auth()?.signInWithCustomToken(token, completion: {
//            (authdata, error) in
//            withCompletion(authData: authdata, error: error)
//        })
        
//        ref.authWithOAuthProvider(provider, token: token, withCompletionBlock: {
//            (error, authData) in
//            withCompletion(firebaseError: error, authData: authData)
//            
//        })
        
    }
    
    func writeToPath(_ path: String?, autoid: Bool, data: [String:Any]) {
        let ref = FIRDatabase.database().reference()
        
        if path != nil {
            
            let pathe = ref.child(path!)
            
            if autoid {
                pathe.childByAutoId().setValue(data)
            } else {
                pathe.setValue(data)
            }
        } else {
                        
            if autoid {
                ref.childByAutoId().setValue(data)
            } else {
                ref.setValue(data)
            }
            
        }
        
        
        
    }
    
    func updatePath(_ path: String, autoID: Bool, data: [String:AnyObject]?) {

        let ref = FIRDatabase.database().reference()
        let path = ref.child(path)
        
        if autoID {
            path.childByAutoId().updateChildValues(data!)
        } else {
            path.updateChildValues(data!)
        }
    }
    
    func readPath(_ path: String?, eventType: FIRDataEventType, completion: @escaping (_ data: FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()

        if path != nil {
            ref.child(path!).observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        } else {
            
            /* Listens for change on path and notifies with completion. Triggered once with all child in NSDictionary or NSArray or similar datatypes */
            ref.observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        }
    }
    
    func readPathOnce(_ path: String?, eventType: FIRDataEventType, completion: @escaping (_ data: FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()
        
        if path != nil {

            ref.child(path!).observeSingleEvent(of: eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        } else {
            ref.observeSingleEvent(of: eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        }
    }
    
    func stopListening() {
        let ref = FIRDatabase.database().reference()
        
        ref.removeAllObservers()
    }
    
    /* Listen for updates on auth status for user. Used when finding out if user is signed in or not */
    func authStatusUpdateWithBlock(_ completion: @escaping (_ authData: FIRUser?) -> Void) {
       // let ref = FIRDatabase.database().reference()
        
        FIRAuth.auth()!.addStateDidChangeListener({
            (auth, user) in
            completion(user)
        })
        
//        ref.observeAuthEventWithBlock({
//            (authData) in
//            completion(authData: authData)
//        })
    }
    
    func queryWithKeyAtPathWithBlock(_ path: String?, key: String, eventType: FIRDataEventType, completion: @escaping (_ snapshot: FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()

        if path != nil {
        
            ref.child(path!).queryOrdered(byChild: key).observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })

        } else {
            ref.queryOrdered(byChild: key).observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        }
    }
    
    func queryWithKey(_ key: String?, atPath path: String?, withEventType eventType: FIRDataEventType, withLast numberOfObjects: UInt, completion: @escaping (FIRDataSnapshot?) -> Void) {
        
        let ref = FIRDatabase.database().reference()
        
        if path != nil && key != nil {
            ref.child(path!).queryOrdered(byChild: key!).queryLimited(toLast: numberOfObjects).observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        } else if path == nil && key != nil {
            ref.queryOrdered(byChild: key!).queryLimited(toLast: numberOfObjects).observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        } else if path == nil && key == nil {
            ref.queryLimited(toLast: numberOfObjects).observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })

        } else if path != nil && key == nil {
            ref.child(path!).queryLimited(toLast: numberOfObjects).observe(eventType, with: {
                (snapshot) in
                completion(snapshot)
            })
        }
        
    }
  
    
    
    

}
