//
//  DriverService.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 05/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import Firebase
import GeoFire

struct DriversService {
    
    static let shared = DriversService()
    
    func updateDriverLocation(location: CLLocation) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let geofire = GeoFire(firebaseRef: driverLocationsRef)
        geofire.setLocation(location, forKey: uid)
    }
    
    func observeTrips(completion: @escaping(Trip) -> Void) {
        tripsRef.observe(.childAdded) { (snapshot) in
            guard let dicitonary = snapshot.value as? [String: Any] else {return}
            
            let trip = Trip(passengerUid: snapshot.key, dictionary: dicitonary)
            completion(trip)
        }
    }
    
    func updateTripState(trip: Trip, state: TripState, completion: (() -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values: [String: Any]
        
        if state == .accepted {
            values = ["driverUid": uid,
                      "state": state.rawValue]
        } else if state == .denied, trip.state == .accepted {
            return
        } else {
            values = ["state": state.rawValue]
        }
        
        tripsRef.child(trip.passengerUid).updateChildValues(values) { (error, _) in
            if let error = error {
                print("DEBUG: failed to update trip state ", state," with error ", error)
                return
            }
            
            guard let completion = completion else {return}
            completion()
        }
        
        if state == .completed {
            tripsRef.child(trip.passengerUid).removeAllObservers()
        }
    }
    
    func observeTripCancelled(trip: Trip, completion: @escaping() -> Void) {
        tripsRef.child(trip.passengerUid).observeSingleEvent(of: .childRemoved) { (_) in
            completion()
        }
    }
    
    
    
}
