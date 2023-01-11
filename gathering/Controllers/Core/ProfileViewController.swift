//
//  ProfileViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let user:User
    
    
    // MARK: - Init
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


}
