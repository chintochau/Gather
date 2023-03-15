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
    
    func showAlert(title: String, message: String = "", buttonText: String, cancelText: String? = "取消", from viewController: UIViewController, buttonCompletion: @escaping () -> Void, cancelCompletion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let cancelText = cancelText {
            let cancelAction = UIAlertAction(title: cancelText, style: .cancel) { _ in
                cancelCompletion?()
            }
            alertController.addAction(cancelAction)
        }
        
        let buttonAction = UIAlertAction(title: buttonText, style: .default) { _ in
            buttonCompletion()
        }
        alertController.addAction(buttonAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }

    
    func showActionSheet(withTitle title: String?, message: String?, firstButtonTitle: String, firstButtonAction: (() -> Void)? = nil, secondButtonTitle: String, secondButtonAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // Add the first button
        let firstButton = UIAlertAction(title: firstButtonTitle, style: .default) { _ in
            // Call the first button closure if it exists
            firstButtonAction?()
        }
        alertController.addAction(firstButton)
        
        // Add the second button
        let secondButton = UIAlertAction(title: secondButtonTitle, style: .default) { _ in
            // Call the second button closure if it exists
            secondButtonAction?()
        }
        alertController.addAction(secondButton)
        
        // Add a cancel button
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        // Find the topmost window to present the alert
        if let topWindow = UIApplication.shared.windows.last {
            topWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }


    
}
