//
//  FacebookOperation.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-06-14.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//

//MARK: -
//MARK: Description

//  Class performs all communication with Facebook API
//  ALL Facebook arrends should go through here

//MARK: -


import Foundation
import FBSDKLoginKit
import FirebaseAuth


class FacebookOperation {

    // Properties
    let permissions: [String]?
    let facebookLogin = FBSDKLoginManager()
    
    // Main init method
    init(permissions: [String]?) {
        self.permissions = permissions
    }
    
    func loginFromViewController(_ viewController: UIViewController, completion: @escaping (_ token: String?, _ facebookError: NSError?, _ credentials: FIRAuthCredential) -> Void) {
        
        // Performs Facebook login request (presents login UI)
        if permissions != nil {
        
            facebookLogin.logIn(withReadPermissions: self.permissions!, from: viewController, handler: {
                (facebookResult, facebookError) -> Void in
                
                
                    // Fetch login token and send it to completion handler together with eventual error message
                    let accessToken = FBSDKAccessToken.current().tokenString
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

                    completion(accessToken, facebookError as NSError?, credential)
            })
        } else {
            print("Permissions is nil (FacebookOperation.swift)")
        }
    }
    
    func logout() {
        self.facebookLogin.logOut()
    }

    func revokePermissions() {
        
        FBSDKGraphRequest.init(graphPath: "me/permissions", parameters: nil, httpMethod: "DELETE").start(completionHandler: {
            (connection, result, error) in
            
        })
    }
    
    func getProfilePicture(completion: @escaping ([String: AnyObject?]?) -> Void) {
        
        FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["height":"500", "redirect":false]).start(completionHandler: {
            (connection, result, error) in
            completion(result as? [String: AnyObject?])
        })

    }
    
    func getName(_ completion: @escaping ([String : AnyObject?]?) -> Void) {
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"name"])
        request.start(completionHandler: {
            (connection, result, error) in
            completion(error as? [String : AnyObject?])
        })
    }
    
    func getAge(_ completion: @escaping (AnyObject?) -> Void) {
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"birthday"])
        request.start(completionHandler: {
            (connection, result, error) in
            
            if let birthday = (result as? [String : AnyObject?])?["birthday"] {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.date(from: birthday as! String)
                let calender = Calendar.current
                let components = (calender as NSCalendar).components(NSCalendar.Unit.year, from: date!)
                let birthYear = components.year
                let currentDate = Date()
                let currentYear = (calender as NSCalendar).components(NSCalendar.Unit.year, from: currentDate).year
                let age = currentYear! - birthYear!
                
                completion(age as AnyObject?)
            } else {
                completion(0 as AnyObject?)
            }
        })
    }
    
    func getFriends(_ completion: @escaping (AnyObject?) -> Void) {
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
        request.start(completionHandler: {
            (connection, result, error) in
            completion(error as AnyObject?)
        })
    }
}
