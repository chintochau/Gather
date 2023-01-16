//
//  TabBarViewController.swift
//  Instagram
//
//  Created by Jason Chau on 2023-01-11.
//

import UIKit
import Foundation

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
//        self.tabBar.isTranslucent = false
        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = .mainColor
        self.tabBar.barTintColor = .mainColor
        
        
        //Define VC
        let home = HomeViewController()
        let explore = ExploreViewController()
        let newevent = NewEventViewController()
        let tickets = TicketViewController()
        let profile = ProfileViewController()
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: newevent)
        let nav4 = UINavigationController(rootViewController: tickets)
        let nav5 = UINavigationController(rootViewController: profile)
        
        
        // Define tab items
        nav1.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "camera"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "heart"), tag: 4)
        nav5.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 5)
        
        if #available(iOS 14.0, *) {
            home.navigationItem.backButtonDisplayMode = .minimal
            explore.navigationItem.backButtonDisplayMode = .minimal
            newevent.navigationItem.backButtonDisplayMode = .minimal
            tickets.navigationItem.backButtonDisplayMode = .minimal
            profile.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
        }
        
        
        nav1.navigationBar.tintColor = .label
//        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        nav5.navigationBar.tintColor = .label
        
        
        if #available(iOS 14.0, *) {
            nav3.navigationItem.backButtonDisplayMode = .minimal
        } else {
            // Fallback on earlier versions
            nav3.navigationItem.backButtonTitle = ""
        }
        
        // set controllers
        self.setViewControllers([nav1,nav2,nav3,nav4,nav5], animated: false)
        
    }
    


}
