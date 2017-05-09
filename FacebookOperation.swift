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
    
    func loginFromViewController(viewController: UIViewController, completion: (token: NSString, facebookError: NSError!, credentials: FIRAuthCredential) -> Void) {
        
        // Performs Facebook login request (presents login UI)
        if permissions != nil {

            facebookLogin.logInWithReadPermissions(self.permissions!, fromViewController: viewController, handler: {
                (facebookResult, facebookError) -> Void in

                
                    // Fetch login token and send it to completion handler together with eventual error message
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)

                    completion(token: accessToken, facebookError: facebookError, credentials: credential)
                
            })
        } else {
            print("Permissions is nil (FacebookOperation.swift)")
        }
    }
    
    func logout() {
        self.facebookLogin.logOut()
    }

    func revokePermissions() {
        
        FBSDKGraphRequest.init(graphPath: "me/permissions", parameters: nil, HTTPMethod: "DELETE").startWithCompletionHandler({
            (connection, result, error) in
            
        })
    }
    
    func getProfilePicture(completion: (AnyObject?) -> Void) {
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["height":"500", "redirect":false])
        request.startWithCompletionHandler({
            (connection, result, error) in
            completion(result)
        })
        
    }
    
    func getName(completion: (AnyObject?) -> Void) {
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"name"])
        request.startWithCompletionHandler({
            (connection, result, error) in
            completion(result)
        })
    }
    
    func getAge(completion: (AnyObject?) -> Void) {
        
        let request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"birthday"])
        request.startWithCompletionHandler({
            (connection, result, error) in
            
            if let birthday = result.objectForKey("birthday") {
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let date = dateFormatter.dateFromString(birthday as! String)
                let calender = NSCalendar.currentCalendar()
                let components = calender.components(NSCalendarUnit.Year, fromDate: date!)
                let birthYear = components.year
                let currentDate = NSDate()
                let currentYear = calender.components(NSCalendarUnit.Year, fromDate: currentDate).year
                let age = currentYear - birthYear
                
                completion(age)
            } else {
                completion(0)
            }
        })
    }
    
    
    
    
}