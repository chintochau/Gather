//
//  ParticipantsViewController.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-29.
//

import UIKit

class ParticipantsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 20
        addGesture()
    }
    
    fileprivate func addGesture() {
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Pan Gesture adjust height
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let y = view.frame.minY
        let swipeSpeed = sender.velocity(in: view).y
        switch sender.state{
        case .began:
            break
        case .changed:
            if y < 100 {
                break
            }
            view.frame = CGRect(
                x: 0,
                y: y + (translation.y),
                width: view.width,
                height: view.height)
            sender.setTranslation(CGPointZero, in: view)
            
            
            print(swipeSpeed)
        case .ended:
            var finalY:CGFloat = 100
            if y < view.height/3.5 {
                // upper half
                if swipeSpeed > 1000 {
                    finalY = view.height/2
                } else {
                    finalY = 100
                }
                
            }else if y > view.height*2/3 {
                // lower half
                if swipeSpeed < -1000 {
                    
                        finalY = view.height/2
                }else {
                    finalY = view.height-100
                    
                }
                
            }else {
                // middle range
                switch swipeSpeed {
                case 1000...:
                    finalY = view.height-100
                case ...(-1000):
                    finalY = 100
                case -1000...1000:
                    finalY = view.height/2
                default:
                        finalY = view.height/2
                }
                
            }
            
            
            UIView.animate(withDuration: 0.2) {
                self.view.frame = CGRect(x: 0, y: finalY, width: self.view.width, height: self.view.height)
            }
            sender.setTranslation(CGPointZero, in: view)
        default:
            break
            
        }
    }
}
