//
//  RegisterViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-15.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var completion: (() -> Void)?
    
    private let titleLabel:UILabel = {
        let view = UILabel()
        view.text = "Create new account"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        return view
    }()
    
    private let usernameField:GATextField = {
        let view = GATextField()
        view.configure(name: "Username")
        view.autocapitalizationType = .none
        view.text = "jjchau"
        view.placeholder = "Enter your username"
        return view
    }()
    
    private let emailField:GATextField = {
        let view = GATextField()
        view.configure(name: "Email")
        view.text = "jj@jj.com"
        view.placeholder = "name@example.com"
        return view
    }()
    
    private let passwordField:GATextField = {
        let view = GATextField()
        view.configure(name: "Password")
        view.text = "password"
        view.placeholder = "Enter your password"
        view.isSecureTextEntry = true
        return view
    }()
    
    private let confirmPasswordField:GATextField = {
        let view = GATextField()
        view.configure(name: "Confirm Password")
        view.text = "password"
        view.placeholder = "Repeat password"
        view.isSecureTextEntry = true
        return view
    }()
    
    private let signUpButton:UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Sign Up", for: .normal)
        view.backgroundColor = .mainColor
        view.layer.cornerRadius = 15
        view.tintColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    private let termsButton:UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Terms", for: .normal)
        view.tintColor = .link
        return view
    }()
    
    private let privacyButton:UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Privacy Policy", for: .normal)
        view.tintColor = .link
        return view
    }()
    
    private let indicator:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector( didTapClose))
        
        view.backgroundColor = .systemBackground
        [titleLabel,
         usernameField,
         emailField,
         passwordField,
         confirmPasswordField,
         signUpButton,
         termsButton,
         privacyButton,
         indicator
        ].forEach{(view.addSubview($0))}
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let padding:CGFloat = 20
        let space:CGFloat = 35
        let fieldWidth:CGFloat = view.width-2*padding
        
        titleLabel.frame = CGRect(x: padding, y: view.safeAreaInsets.top+10, width: view.width - 2*space, height: 30)
        
        usernameField.frame = CGRect(x: padding, y: titleLabel.bottom+50, width: fieldWidth, height: 50)
        emailField.frame = CGRect(x: padding, y: usernameField.bottom+space, width: fieldWidth, height: 50)
        passwordField.frame = CGRect(x: padding, y: emailField.bottom+space, width: fieldWidth, height: 50)
        confirmPasswordField.frame = CGRect(x: padding, y: passwordField.bottom+space, width: fieldWidth, height: 50)
        termsButton.sizeToFit()
        termsButton.frame = CGRect(x: padding, y: confirmPasswordField.bottom+30, width: fieldWidth, height: termsButton.height)
        privacyButton.frame = CGRect(x: padding, y: termsButton.bottom, width: fieldWidth, height: termsButton.height)
        
        let buttonHeight:CGFloat = 50
        signUpButton.frame = CGRect(x: padding, y: view.height-buttonHeight-30, width: fieldWidth, height: buttonHeight)
        
        indicator.frame = CGRect(x: signUpButton.left, y: signUpButton.top, width: signUpButton.width, height: signUpButton.height)
        
        
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true)
    }
    @objc private func didTapSignUp(){
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let username = usernameField.text, !username.isEmpty,
              let confirmPassword = confirmPasswordField.text, confirmPassword == password
        else {
            return
        }
        indicator.startAnimating()
        indicator.isHidden = false
        signUpButton.isHidden = true
        
        AuthManager.shared.signUp(username: username, email: email, password: password) {[weak self] user in
            guard let user  = user else {
                
                let alert = UIAlertController(title: "Oops~", message: "Account already exist, please try login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
                self?.present(alert, animated: true)
                
                self?.indicator.isHidden = true
                self?.signUpButton.isHidden = false
                return
            }
            
            UserDefaultsManager.shared.updateUserProfile(with: user)
            self?.completion?()
            self?.dismiss(animated: true)
        }
    }
}


