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
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.text = K.username
        view.placeholder = "Enter your username"
        view.keyboardType = .alphabet
        return view
    }()
    
    private let emailField:GATextField = {
        let view = GATextField()
        view.configure(name: "Email")
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.text = K.email
        view.placeholder = "name@example.com"
        view.keyboardType = .emailAddress
        return view
    }()
    
    private let passwordField:GATextField = {
        let view = GATextField()
        view.configure(name: "Password")
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.text = K.password
        view.placeholder = "Enter your password"
        view.isSecureTextEntry = true
        return view
    }()
    
    private let confirmPasswordField:GATextField = {
        let view = GATextField()
        view.configure(name: "Confirm Password")
        view.text = K.password
        view.placeholder = "Repeat password"
        view.isSecureTextEntry = true
        return view
    }()
    
    
    private let agreeText:UILabel = {
        let view = UILabel()
        view.text = Policy.agreedMessage
        view.numberOfLines = 2
        view.font = .systemFont(ofSize: 14)
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
         indicator,
         agreeText
        ].forEach{(view.addSubview($0))}
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        
        addTapCancelGesture()
        
        usernameField.delegate = self
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
        
        let buttonHeight:CGFloat = 50
        termsButton.frame = CGRect(x: padding, y: view.height-buttonHeight-60-55, width: fieldWidth, height: termsButton.height)
        privacyButton.frame = CGRect(x: padding, y: view.height-buttonHeight-60-35, width: fieldWidth, height: termsButton.height)
        
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(didTapPrivacy), for: .touchUpInside)
        
        agreeText.sizeToFit()
        agreeText.frame = CGRect(x: padding, y: view.height-buttonHeight-60-10, width: fieldWidth, height: agreeText.height)
        
        signUpButton.frame = CGRect(x: padding, y: view.height-buttonHeight-30, width: fieldWidth, height: buttonHeight)
        indicator.frame = CGRect(x: signUpButton.left, y: signUpButton.top, width: signUpButton.width, height: signUpButton.height)
        
        
    }
    
    private func addTapCancelGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCancel))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    
    
    @objc private func didTapPrivacy() {
        let vc = PolicyViewController(title: "Privacy Policy", policyString: Policy.privacyPolicy)
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    @objc private func didTapTerms() {
        let vc = PolicyViewController(title: "Terms", policyString: Policy.terms)
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
        
    }
    
    @objc private func didTapCancel(){
        view.endEditing(true)
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
            
            DefaultsManager.shared.updateUserProfile(with: user)
            self?.completion?()
            self?.dismiss(animated: true)
            CustomNotificationManager.shared.requestForNotification()
        }
    }
    
}



extension RegisterViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text {
            textField.text = text.lowercased()
        }
        
    }
    
}
