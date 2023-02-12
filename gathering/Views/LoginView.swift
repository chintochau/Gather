//
//  LoginView.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-13.
//

import UIKit

protocol LoginViewDelegate:AnyObject {
    func didTapLogin (_ view:LoginView, email:String,password:String)
}

class LoginView: UIView, UITextFieldDelegate {
    
    weak var delegate:LoginViewDelegate?
    
    private let title:UILabel = {
        let view = UILabel()
        view.text = "Welcome back"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.numberOfLines = 2
        return view
    }()
    
    
    private let emailField:GATextField = {
        let view = GATextField()
        view.configure(name: "Email")
        view.text = K.email
        view.autocapitalizationType = .none
        view.placeholder = "name@example.com"
        view.autocorrectionType = .no
        view.keyboardType = .emailAddress
        return view
    }()
    
    private let passwordField:GATextField = {
        let view = GATextField()
        view.configure(name: "Password")
        view.text = K.password
        view.placeholder = "Enter your password"
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.isSecureTextEntry = true
        return view
    }()
    
    
    let loginButton:UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Login", for: .normal)
        view.backgroundColor = .mainColor
        view.layer.cornerRadius = 15
        view.tintColor = .white
        view.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    let registerButton:UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Dont have account yet? Create here", for: .normal)
        view.tintColor = .link
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
    
    let indicator:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        [title,
         emailField,
         passwordField,
         loginButton,
         termsButton,
         privacyButton,
         registerButton,
         indicator
        ].forEach{(addSubview($0))}
        
        loginButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
    }
    
    @objc private func didTapView(){
        endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTitle(text:String){
        title.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding:CGFloat = 20
        let space:CGFloat = 35
        let fieldWidth:CGFloat = width-2*padding
        title.frame = CGRect(x: padding, y: 10, width: width - 2*space, height: 80)
        
        emailField.frame = CGRect(x: padding, y: title.bottom+100, width: width-2*padding, height: 50)
        passwordField.frame = CGRect(x: padding, y: emailField.bottom+space, width: width-2*padding, height: 50)
        registerButton.sizeToFit()
        registerButton.frame = CGRect(x: padding, y: passwordField.bottom+20, width: fieldWidth, height: registerButton.height)
        
        
        let buttonHeight:CGFloat = 50
        termsButton.frame = CGRect(x: padding, y: height-buttonHeight-30-60, width: fieldWidth, height: registerButton.height)
        privacyButton.frame = CGRect(x: padding, y: height-buttonHeight-30-30, width: fieldWidth, height: registerButton.height)
        
        loginButton.frame = CGRect(x: padding, y: height-buttonHeight-30, width: width-2*padding, height: buttonHeight)
        indicator.frame = loginButton.frame
        
        emailField.delegate = self
        passwordField.delegate = self
        
    }
    
    @objc private func didTapSignIn(){
        guard let email = emailField.text, let password = passwordField.text else {return}
        indicator.startAnimating()
        loginButton.isHidden = true
        delegate?.didTapLogin(self, email: email, password: password)
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

