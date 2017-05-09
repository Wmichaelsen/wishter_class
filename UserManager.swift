//
//  UserManager.swift
//  Looking4friends
//
//  Created by Wilhelm Michaelsen on 2016-06-15.
//  Copyright © 2016 Wilhelm Michaelsen. All rights reserved.
//


//MARK: -
//MARK: Description

//  Main API for user operations. Login, create profile and match making

//MARK: -


import UIKit
import Firebase
import CoreLocation
import FirebaseAuth


class UserManager: NSObject, LocationManagerDelegate {
    
    /**********************************************************************************************************************************************************************/
    /********************************************************************   PROPERTIES   **********************************************************************************/
    /**********************************************************************************************************************************************************************/
    
    /* Private properties */
    private let createProfile: CreateProfile
    private let login: Login
    private let firebaseOperation: FirebaseOperation
    private let facebookOperation: FacebookOperation
    private let matcher: Matcher
    private let BASE_URL: String
    
    /* Private properties for converting coordinates to common name */
    var commonName: String?
    let googleAPIKey: String = "AIzaSyBXitsQKrPMTud9N-hx0gq10S-0v67jpqo"
    
    /* Public properties */
    var uid: String?
    var userMatches: NSMutableArray?
    var profile: NSMutableDictionary?
    var interests: NSMutableArray?
    var categories: NSMutableArray?
    var selectedCategories: NSMutableArray?
    var currentUserName: String?
    var currentUser: FIRDataSnapshot?
    var currentUserLocation: [Double]?
    var hasLoadedRangeLabel: Bool?
    var userAgePref: [Int]?
    var userDistancePref: Int?
    
    let defaultImage: UIImage? = UIImage(named: "erlich.jpg")
        
    
    /**********************************************************************************************************************************************************************/
    /********************************************************************   PUBLIC METHODS   ******************************************************************************/
    /**********************************************************************************************************************************************************************/
    
    override init() {
        login = Login()
        BASE_URL = "https://amikoo.firebaseio.com/"
        firebaseOperation = FirebaseOperation(url: BASE_URL)
        facebookOperation = FacebookOperation(permissions: nil)
        matcher = Matcher()
        createProfile = CreateProfile(baseURL: self.BASE_URL)
        currentUserLocation = [0]
        
        uid = ""
        userMatches = NSMutableArray()
        profile = nil
        interests = NSMutableArray()
        categories = NSMutableArray()
        selectedCategories = NSMutableArray()
        currentUserName = ""
        hasLoadedRangeLabel = false
        userAgePref = [25,40]
        userDistancePref = 20
        
        super.init()
        
        LocationManager.sharedInstance.delegate = self
    }
    
    class var sharedInstance: UserManager {
        
        struct Singleton {
            static let instance = UserManager()
        }
        
        return Singleton.instance
    }
    
    func unAuth() {
        firebaseOperation.unAuth()
    }
    
    func createProfileAtPath(path: String, profile: [String:AnyObject]) {
        createProfile.create(profile, path: path)
    }
    
    func updateProfileName(userID: String?, newName: String?) {
        createProfile.updateUserName(userID, newName: newName)
    }
    
    func updateProfileAge(userID: String?, newAge: Int?) {
        createProfile.updateUserAge(userID, newAge: newAge)
    }
    
    func updateProfileAgePreference(userID: String?, newAgePref: [Int]?) {
        createProfile.updateUserPreferencesAge(userID, newAgePref: newAgePref)
    }
    
    func updateProfileDistancePreference(userID: String?, newDistancePref: Int?) {
        createProfile.updateUserPreferencesDistance(userID, newDistancePref: newDistancePref)
    }
    
    func updateProfileStatus(userID: String?, status: String?) {
        createProfile.updateUserStatus(userID, status: status)
    }
    
    func updateProfileInterests(userID: String?, newInterests: NSMutableArray?) {
        if newInterests != nil {
            self.createProfile.updateUserInterests(userID, interests: newInterests! as NSArray as? [String])
        } else {
            print("newInterests is nil (UserManager.swift")
        }
    }
    
    func deleteProfileInterest(userID: String?, interest: String?) {
        
        if interest != nil {
        
            self.getUserInterests(userID, completion: {
                (intrests) in
                
                if intrests != nil {
                    
                    let inte = intrests
                    
                    if self.interestAlreadyExists(interest) {
                        inte?.removeObject(interest!)
                        self.createProfile.updateUserInterests(userID, interests: inte! as NSArray as? [String])
                    }
                    
                } else {
                    print("intrests is nil (UserManager.swift")
                }
                
            })
        } else {
            print("interest is nil (UserManager.swift")
        }
        
    }
    
    func login(viewController: UIViewController, completion: (facebookError: NSError!, firebaseError: NSError!, authData: FIRUser) -> Void) {
        
        login.setFirebaseURL(BASE_URL)
        login.setFBPermission(["email", "public_profile", "user_birthday"])

        login.loginFromViewController(viewController, completion: {
            (facebookError, firebaseError, authData) in
            completion(facebookError: facebookError, firebaseError: firebaseError, authData: authData)
        })
        
    }
    
    func writeToPath(path: String?, autoID: Bool, data: [String:AnyObject]) {
        firebaseOperation.writeToPath(path, autoid: autoID, data: data)
    }
    
    /* Listen for user auth updates. Used when finding out if user is signed in or not */
    func userAuthStatusWithBlock(completion: (authData: FIRUser?) -> Void) {
        
        firebaseOperation.authStatusUpdateWithBlock({
            (authData) in
            
            if authData != nil {
                self.uid = authData!.uid
            } else {
                print("authData is nil (UserManager.swift)")
            }
            completion(authData: authData)
        })
    }
    
    /* Read data at specific path */
    func readDataAtPath(path: String, eventType: FIRDataEventType, completion: (data: FIRDataSnapshot!) -> Void) {
        firebaseOperation.readPath(path, eventType: eventType, completion: {
            (data) in
            completion(data: data)
        })
    }
    
    /* Read data at specific path ONLY ONCE */
    func readDataAtPathOnce(path: String, completion: (data: FIRDataSnapshot?) -> Void) {
        firebaseOperation.readPathOnce(path, eventType: .Value, completion: {
            (data) in
            completion(data: data)
        })
    }
    
    /* Find matches for current user ordered by age (youngest to oldest) */
    func getMatchesOrderedByAge(withBlock completion: (user: NSDictionary?, error: String?) -> Void) {
        
        if self.uid != nil {
            self.readDataAtPath("/matches/\(self.uid!)", eventType: .ChildAdded, completion: {
                (match) in
                if match != nil {
                    self.getProfileForUser(match.value as? String, completion: {
                        (userSnapshot) in
                        completion(user: userSnapshot, error: nil)
                    })
                }
            })
        } else {
            completion(user: nil, error: "uid is nil (UserManager.swift)")
        }
    }
    
    /* Sort matches */
    func sortMatchesBy(sortType: String?, matchesArray: NSMutableArray?) -> NSMutableArray? {
        
        
        
        return nil
    }

    /* Get Facebook profile picture */
    func getProfilePicture(completion: (AnyObject?) -> Void) {
        facebookOperation.getProfilePicture({
            (results) in
            completion(results)
            
        })
    }
    
    /* Get Facebook profile name */
    func getFacebookName(completion: (AnyObject?) -> Void) {
        facebookOperation.getName({
            (result) in
            completion(result)
        })
    }
    
    /* Get Facebook profile age */
    func getFacebookAge(completion: (AnyObject?) -> Void) {
        facebookOperation.getAge({
            (result) in
            completion(result)
        })
    }
    
    /* Get Facebook profile name, age and picture */
    func getFacebookProfileDetails(completion: ([String:AnyObject]?) -> Void) {
        self.facebookOperation.getProfilePicture {
            (picture) in
            
            self.facebookOperation.getName({
                (name) in
                
                self.facebookOperation.getAge({
                    (age) in
                    if picture != nil && name != nil && age != nil {
                        completion(["picture":picture!, "name":name!, "age":age!])
                    } else {
                        completion(nil)
                    }
                })
                
            })
            
        }
    }
    
    /* Revoke Facebook permission */
    func revokeFacebookPermissions() {
        facebookOperation.revokePermissions()
    }
    
    func logout() {
        login.logout()
    }
    
    /* Get user name from user ID */
    func getUsernameFromID(userID: String, completion: (String?) -> Void) {
        self.queryAtPath("users/", withKey: "name", completion: {
            (user) in
            if user != nil {
                if user!.key == userID {
                    completion((user!.value!.objectForKey("name") as? String)!)
                }
            } else {
                print("user is nil UserManager.swift")
            }
        })
    }
    
    /* Use to retrieve user profile from ID */
    func getProfileForUser(userID: String?, completion: (NSMutableDictionary?) -> Void) {
        if userID != nil {
            
            self.readDataAtPathOnce("/users", completion: {
                (users) in
                let array = ((users!.value!.objectForKey(userID!) as! [String: AnyObject]) as NSDictionary)
                let array2 = NSMutableDictionary(dictionary: array)
                array2.setValue(userID!, forKey: "id")
                completion(array2)
            })
            
        }
    }
    
    /* Get current location for user */
    func startUpdatingLocation() {
        LocationManager.sharedInstance.requestPermissionAndStartUpdateLocation()
    }
    
    func stopUpdatingLocation() {
        LocationManager.sharedInstance.stopUpdating()
    }
    
    /* Update current user's location in database */
    func updateDataAtPath(path: String, autoid: Bool, newData:[String:AnyObject]) {
        firebaseOperation.updatePath(path, autoID: autoid, data: newData)
    }
    
    func queryAtPath(path: String, withKey key: String, completion: (FIRDataSnapshot?) -> Void) {
        firebaseOperation.queryWithKeyAtPathWithBlock(path, key: key, eventType: .ChildAdded, completion: {
            (snapshot) in
            completion(snapshot)
        })
    }
    
    func loadProfilePictureURL(userID: String, completion: (NSURL?) -> Void) {
        
        UserManager.sharedInstance.readDataAtPathOnce("users/\(userID)", completion: {
            (user) in
            
            if !(user?.value is NSNull) {
                completion(NSURL(string:(user!.value!.objectForKey("pictureURL") as? String)!))
            } else {
                print("user is nil (ChatListTableViewController.swift)")
            }
        })
    }
    
    /* Use to fetch a user's interests */
    func getUserInterests(userID: String?, completion: (NSMutableArray?) -> Void) {
        
        if userID != nil {
            self.readDataAtPathOnce("users/\(userID!)", completion: {
                (user) in
                if user != nil {
                    completion(user!.value!.objectForKey("interests") as? NSArray as? NSMutableArray)
                } else {
                    print("user is nil (UserManager.swift)")
                }
            })
        } else {
            print("userID is nil (UserManager.swift)")
        }
    }
    
    func interestAlreadyExists(interest: String?) -> Bool {
        
        if UserManager.sharedInstance.interests != nil && interest != nil {
            
            /* Iterate over all existing interests */
            for existingInterest in UserManager.sharedInstance.interests! {
                
                if interest! == existingInterest as! String {
                    // Already exists: return true
                    return true
                }
            }
        } else {
            print("UserManager.sharedInstance.interests or passed interest is nil (UserManager.swift)")
        }
        
        /* Return false by default */
        return false

    }

    /* Haversine formula to calculate distance between two coordinates */
    func gerDistanceBetween(point1: [Double]?, and point2: [Double]?) -> Double? {
        if point1 != nil && point2 != nil {
            
            let radianFactor: Double = 0.0174532925
            let R: Double = 6371.0
            let o1 = point1![0] * radianFactor
            let o2 = point2![0] * radianFactor
            let deltaO = (point2![0]-point1![0]) * radianFactor
            let deltaY = (point2![1]-point1![1]) * radianFactor
            
            let a = sin(deltaO/2) * sin(deltaO/2) + cos(o1) * cos(o2) * sin(deltaY/2) * sin(deltaY/2)
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            
            let d = R * c
            
            return d
        }
        
        return nil
    }
    
    /* Used to convert FDataSnapshot to NSDictionary */
    func snapshotToDictionary(snapshot: FIRDataSnapshot?) -> NSMutableDictionary? {
        
        if snapshot != nil {
            
            let userr = snapshot!.value as? NSDictionary
            let id = snapshot!.key
            let age = userr?.objectForKey("age")! as? Int
            let interests = userr?.objectForKey("interests")! as? [String]
            let location = userr?.objectForKey("location")! as? [Double]
            let locationName = userr?.objectForKey("locationName")! as? String
            let name = userr?.objectForKey("name")! as? String
            let pictureURL = userr?.objectForKey("pictureURL")! as? String
            let agePref = (userr?.objectForKey("preferences") as? NSDictionary)?.objectForKey("age")! as? [Int]
            let distancePref = (userr?.objectForKey("preferences") as? NSDictionary)?.objectForKey("distance")! as? Int
            let preferences = ["age":agePref!, "distance":distancePref!]
            let status = userr?.objectForKey("status") as? String
            
            let clLocation = CLLocation(latitude: (location![0]), longitude: (location![1]))
            
            return ["id":id, "age":age!, "interests":interests!, "location":clLocation, "locationName":locationName!, "name":name!, "pictureURL":pictureURL!, "preferences":preferences, "status":status!]
            
            
        }
        
        return nil
    }
    
    /* Used to convert Conversation FDataSnapshot to NSDictionary */
    func conversationSnapshotToDictionary(snapshot: FIRDataSnapshot?) -> NSMutableDictionary? {
        
        if snapshot != nil {

            let conversation = snapshot!.value as? NSDictionary
            let id = snapshot!.key
            let user1 = conversation?.objectForKey("user1")! as? String
            let user2 = conversation?.objectForKey("user2")! as? String
            
            if let messages = (snapshot!.value as? NSDictionary)?.objectForKey("messages") {
                return ["id":id, "messages":messages, "user1":user1!, "user2":user2!]
            } else {
                return ["id":id, "user1":user1!, "user2":user2!]
            }
        }
        
        return nil
    }
    
    func sortMatches(matches: NSMutableArray?, by sortType: String?) -> NSMutableArray? {
        return matcher.sortMatches(sortType, matchesArray: matches)
    }
    
    /**********************************************************************************************************************************************************************/
    /********************************************************************   DELEGATE METHODS   *****************************************************************************/
    /**********************************************************************************************************************************************************************/
    
    
    //MARK: - LocationManagerDelegate methods
    func locationChanged(coordinate: CLLocationCoordinate2D?) {
        if coordinate != nil {
            let coordinates: [Double] = [coordinate!.latitude, coordinate!.longitude]
                        
            self.coordinatesToCommonName(coordinates, completion: {
                (commonName) in
                
                if commonName != nil {
                    if self.uid != nil {
                        self.updateDataAtPath("users/\(self.uid!)", autoid: false, newData: ["location":coordinates, "locationName":commonName!])
                    } else {
                        print("self.uid is nil UserManager.swift")
                    }
                } else {
                    print("commonName is nil (UserManager.swift)")
                }
            })
            
            /* Update local location variable */
            self.currentUserLocation = coordinates
            
        } else {
            print("coordinate is nil (UserManager.swift)")
        }
    }
    
    
    /**********************************************************************************************************************************************************************/
    /********************************************************************   PRIVATE METHODS   *****************************************************************************/
    /**********************************************************************************************************************************************************************/
    //MARK: - Private methods
    
    /* Using Google Geolocation API to turn coordinates into common name by parsing the JSON return */
    private func coordinatesToCommonName(coordinates: [Double], completion: (commonName: String?) -> Void) {
        
        let URL: NSURL? = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinates[0]),\(coordinates[1])&key=\(self.googleAPIKey)")!
        if URL != nil {
            
            NSURLSession.sharedSession().dataTaskWithURL(URL!, completionHandler: {
                (data, response, error) in
                var json: AnyObject
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                    
                    let components: NSArray = (json.objectForKey("results")![0].objectForKey("address_components")! as? NSArray)!
                    
                    for componentDic in components {
                        
                        if ((componentDic as? NSMutableDictionary)!.objectForKey("types")! as! Array)[0] == "postal_town" {
                            self.commonName = (componentDic as? NSMutableDictionary)!.objectForKey("short_name")! as? String
                            completion(commonName: self.commonName!)
                        } else if ((componentDic as? NSMutableDictionary)!.objectForKey("types")! as! Array)[0] == "country" {
                            completion(commonName: self.commonName?.stringByAppendingString(", \(((componentDic as? NSMutableDictionary)!.objectForKey("long_name")! as? String)!)"))
                        }
                        
                    }
                    
                    
                } catch {
                    print(error)
                }
                
            }).resume()
            
        } else {
            print("Couldn't construct URL from String (ProfileViewController.swift)")
        }
    }
    
    

    
    
    
}
