//
//  AuthButton.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 06/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import UIKit

class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        backgroundColor = Constants.Color.primaryColor
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
