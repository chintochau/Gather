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
    
    func showAlert(title: String, message: String = "", buttonText: String, cancelText: String? = "取消",from viewController: UIViewController, completion: @escaping () -> Void) {
            
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
        if let cancelText = cancelText {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
        }
            
        let buttonAction = UIAlertAction(title: buttonText, style: .default) { _ in
            completion()
        }
        alertController.addAction(buttonAction)
        
        viewController.present(alertController, animated: true, completion: nil)
        
    }
    
}
