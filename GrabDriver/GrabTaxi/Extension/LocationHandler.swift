//
//  LocationHandler.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 06/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHandler()
    
    var locationManager: CLLocationManager!
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
}
