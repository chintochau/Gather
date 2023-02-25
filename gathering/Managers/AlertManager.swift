//
//  AlertManager.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-24.
//

import UIKit

struct AlertManager {
    
    // Singleton instance
    static let shared = AlertManager()
    
    func showAlert(title: String, message: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
