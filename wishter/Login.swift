//
//  Login.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-06-14.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

// Handles the communication between ViewControllers and FirebaseOperation and FacebookOperation at login stage


import Foundation
import UIKit
import Firebase
import FirebaseAuth

class Login {

    /* Properties */
    var fbPermissions: [String]?
    var firebaseURL: String!
    
    /* Main init method (sets permission to gain access to and what base URL to use for Firebase) */
    init() {
        fbPermissions = nil
        firebaseURL = nil
    }
    
    func setFBPermission(_ permissions: [String]?) {
        fbPermissions = permissions
    }
    
    func setFirebaseURL(_ url: String) {
        firebaseURL = url
    }
    

    /* Main facebook-login method. Sends back (through completion) any firebase- or facebook errors, as well as the authData */
    func loginFromViewController(_ viewController: UIViewController, completion: @escaping (_ firebaseError: NSError?, _ facebookError: NSError?, _ authData: FIRUser) -> Void) {

        let facebookbOp = FacebookOperation(permissions: fbPermissions)
        let firebaseOp = FirebaseOperation(url: firebaseURL)
        
        facebookbOp.loginFromViewController(viewController, completion: {
            (accessToken, facebookError, credential) in
            
            if accessToken != nil {
            
                firebaseOp.authenticateWithProvider("facebook", token: accessToken! as String, credential: credential, withCompletion: {
                    (authdata, error) in
                    completion(error as NSError?, facebookError, authdata!)
                
                })
            } else {
                print("AccessToken is nil (Login.swift)")
            }
        })
    
    }
    
    func logout() {
        let facebookOp = FacebookOperation(permissions: fbPermissions)
        let firebaseOp = FirebaseOperation(url: "https://wishter-f0c10.firebaseio.com/")
        
        facebookOp.logout()
        firebaseOp.unAuth()
    }

    
    
}
