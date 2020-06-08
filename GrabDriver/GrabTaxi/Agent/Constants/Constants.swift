//
//  Constants.swift
//  SearchModule
//
//  Created by Navnit Baldha on 05/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import Foundation
import UIKit

typealias DownloadComplete = () -> ()
struct Constants {
    
    //URLs
    struct URL
    {
        
    }
    
    //header
    static let headers = [
        "Content-Type": "application/json",
        "Accept": "application/json",
    ]
    
    
    static let headersImage = [
        "Content-Type": "image/png",
        ]
    
    //color
    struct Color {
        static let primaryColor = UIColor(red: 0.0/255, green: 184.0/255, blue: 60.0/255, alpha: 1.0) // 00B83C
        static let whiteColor = UIColor.white
        static let blackColor = UIColor.black
        static let secondaryPrimeColor = UIColor(red: 0.0/255, green: 184.0/255, blue: 60.0/255, alpha: 1.0)
        static let lightGrayColor = UIColor.lightGray
        
        static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
        static let mainBlueTint = UIColor.rgb(red: 17, green: 154, blue: 232)
        
    }

    //Pref
    struct Pref
    {
        static let grabIconImg = "grabIcon"
        static let lockImg = "lock"
        static let mailImg = "mail"
        static let menuImg = "menu"
        static let personImg = "person"
        static let accountBoxImg = "accountBox"
        static let annotationImg = "annotation"
        static let backArrowImg = "backArrow"
        static let carImg = "car"
        static let exitImg = "exit"
    }
    
    //String
    struct String
    {
        static let title = "Grab Shuttle"
        static let email = "Email"
        static let fullname = "Full Name"
        static let password = "Password"
        static let signup = "Sign Up"
        static let haveanaccount = "Have an account?  "
        static let login = "Login"
        static let donthaveanaccount = "Don't have an account?  "
        
       
    }
    
}

