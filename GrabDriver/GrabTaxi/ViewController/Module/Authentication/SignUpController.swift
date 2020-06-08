//
//  SignUpController.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 05/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class SignUpController: UIViewController {
    
    // MARK: - Properties
    
    private var location = LocationHandler.shared.locationManager.location
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.Pref.grabIconImg) 
        return imageView
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField().textField(withPlaceholder: Constants.String.email, isSecureTextEntry: false)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var emailContainerView: UIView = {
        return UIView().inputContainerView(withImage: UIImage(named: Constants.Pref.mailImg), textField: self.emailTextField)
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = UITextField().textField(withPlaceholder: Constants.String.fullname, isSecureTextEntry: false)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var fullNameContainerView: UIView = {
        return UIView().inputContainerView(withImage: UIImage(named: Constants.Pref.personImg), textField: self.fullNameTextField)
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField().textField(withPlaceholder: Constants.String.password, isSecureTextEntry: true)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordContainerView: UIView = {
        return UIView().inputContainerView(withImage: UIImage(named: Constants.Pref.lockImg), textField: self.passwordTextField)
    }()
    
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle(Constants.String.signup, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailContainerView, self.passwordContainerView, self.fullNameContainerView, self.signUpButton])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 24
        return stack
    }()
    
    private let haveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: Constants.String.haveanaccount, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: Constants.String.login, attributes: [NSAttributedString.Key.foregroundColor: Constants.Color.primaryColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()    
}


extension SignUpController
{
    // MARK: - Lifecycle
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
          view.backgroundColor = Constants.Color.backgroundColor
          
          configureUI()
      }
      
      override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
      }
    
    // MARK: - Helper Functions
       
       func configureUI() {
           
           view.backgroundColor = Constants.Color.backgroundColor
           
           view.addSubview(logoImage)
           logoImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor)
           
           view.addSubview(signUpStackView)
           signUpStackView.anchor(top: logoImage.bottomAnchor, paddingTop: 40, left: view.leftAnchor, paddingLeft: 16, right: view.rightAnchor, paddingRight: 16)
           
           view.addSubview(haveAccountButton)
           haveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, height: 32)
       }
       
       func uploadUserDataAndDismiss(uid: String, values: [String: Any]) {
           usersRef.child(uid).updateChildValues(values) { (error, _) in
               if let error = error {
                   print("DEBUG: Failed to save user data with error ", error)
                   Auth.auth().currentUser?.delete(completion: { (error) in
                       if let error = error {
                           print("DEBUG: Failed to delete user with error ", error)
                       }
                       self.signUpButton.isEnabled = true
                       return
                   })
               }
               print("DEBUG: Successfully Registered user")
               guard let containerController = UIApplication.shared.keyWindow?.rootViewController as? ContainerController else {return}
               containerController.homeController.handleLoggedIn()
               self.dismiss(animated: true)
           }
       }
       
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullName = fullNameTextField.text else {return}
        let accountTypeIndex = 1
        
        signUpButton.isEnabled = false
        
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error ", error)
                self.signUpButton.isEnabled = true
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let values = ["email": email, "fullName": fullName, "accountType": accountTypeIndex] as [String: Any]
            self.uploadUserDataAndDismiss(uid: uid, values: values)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && fullNameTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = Constants.Color.primaryColor
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = Constants.Color.primaryColor.withAlphaComponent(0.5)
        }
        
    }
}
