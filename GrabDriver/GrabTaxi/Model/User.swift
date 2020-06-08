//
//  User.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 05/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import Foundation
import CoreLocation

enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    
    let uid: String
    let fullName: String
    let email: String
    let accountType: AccountType
    var location: CLLocation?
    var homeLocation: String?
    var workLocation: String?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = AccountType(rawValue: dictionary["accountType"] as! Int)!
        self.homeLocation = dictionary["home"] as? String ?? nil
        self.workLocation = dictionary["work"] as? String ?? nil
    }
}
