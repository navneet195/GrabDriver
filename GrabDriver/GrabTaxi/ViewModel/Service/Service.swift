//
//  Service.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 05/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//


import Firebase

let dbRef = Database.database().reference()
let usersRef = dbRef.child("users")
let driverLocationsRef = dbRef.child("driver-locations")
let tripsRef = dbRef.child("trips")

struct Service {
    
    static let shared = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        usersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            completion(User(uid: uid, dictionary: dictionary))
            
        }) { (error) in
            print("DEBUG: Fialed to fetch user data with error ", error)
        }
    }

}
