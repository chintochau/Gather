//
//  TransitionManager.swift
//  gathering
//
//  Created by Jason Chau on 2023-01-12.
//

import Foundation
import UIKit

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // MARK: - home to event
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? HomeViewController, // 1
            let toViewController = transitionContext.viewController(forKey: .to) as? EventMainViewController, // 2
            let eventCell = fromViewController.currentCell, // 3
            let eventCellImageView = fromViewController.currentCell?.eventImageView //4
        else {return}
        //        let eventDetailHeaderView = toViewController // 5
        
        
        let containerView = transitionContext.containerView // 6
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .systemBackground
        snapshotContentView.frame = containerView.convert(eventCell.eventImageView.frame, from: eventCell)
        snapshotContentView.layer.cornerRadius = eventCell.eventImageView.layer.cornerRadius
        
        let snapshotEventImageView = UIImageView()
        snapshotEventImageView.clipsToBounds = true
        snapshotEventImageView.contentMode = eventCellImageView.contentMode
        snapshotEventImageView.image = eventCellImageView.image
        snapshotEventImageView.layer.cornerRadius = eventCellImageView.layer.cornerRadius
        snapshotEventImageView.frame = containerView.convert(eventCellImageView.frame, from: eventCell)
        
        containerView.addSubview(toViewController.view) // 7
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotEventImageView)
        
        toViewController.view.isHidden = true // 8
        
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
            snapshotEventImageView.frame = containerView.convert(toViewController.imageView.frame, from: toViewController.imageView)
            snapshotEventImageView.layer.cornerRadius = 0
        }
        
        animator.addCompletion { position in
            toViewController.view.isHidden = false
            snapshotEventImageView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }
        
        animator.startAnimation()
    }
}
