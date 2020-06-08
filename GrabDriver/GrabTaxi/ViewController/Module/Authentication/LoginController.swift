//
//  LoginController.swift
//  GrabDriver
//
//  Created by Navnit Baldha on 05/06/20.
//  Copyright © 2020 Navneet Baldha. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController{
    
    // MARK: - Properties
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
    
    private let passwordTextField: UITextField = {
        let textField = UITextField().textField(withPlaceholder: Constants.String.password, isSecureTextEntry: true)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordContainerView: UIView = {
        return UIView().inputContainerView(withImage: UIImage(named: Constants.Pref.lockImg), textField: self.passwordTextField)
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle(Constants.String.login, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.emailContainerView, self.passwordContainerView, self.loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        return stack
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: Constants.String.donthaveanaccount, attributes: [NSAttributedString.Key.foregroundColor: Constants.Color.lightGrayColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: Constants.String.signup, attributes: [NSAttributedString.Key.foregroundColor: Constants.Color.secondaryPrimeColor, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
}

extension LoginController
{
    // MARK: - Lifecycle
      
      override func viewDidLoad() {
          super.viewDidLoad()
          
          configureUI()
      }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        configureNavigationBar()
        
        view.backgroundColor = Constants.Color.backgroundColor

        view.addSubview(logoImage)
        logoImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, centerX: view.centerXAnchor)
        
        view.addSubview(loginStackView)
        loginStackView.anchor(top: logoImage.bottomAnchor, paddingTop: 40, left: view.leftAnchor, paddingLeft: 16, right: view.rightAnchor, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, height: 32)
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        loginButton.isEnabled = false
        
        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                print("DEBUG: Failed to login with error ", error)
                self.loginButton.isEnabled = true
                return
            }
            
            print("Successfully logged user in..")
            guard let containerController = UIApplication.shared.keyWindow?.rootViewController as? ContainerController else {return}
            containerController.homeController.handleLoggedIn()
            self.dismiss(animated: true)

        }
    }
    
    @objc func handleShowSignUp() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = Constants.Color.primaryColor
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = Constants.Color.primaryColor.withAlphaComponent(0.5)
        }
        
    }
}
