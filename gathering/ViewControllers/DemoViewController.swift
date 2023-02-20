//
//  DemoViewController.swift
//  Gather Pool
//
//  Created by Jason Chau on 2023-02-20.
//

import UIKit

class DemoViewController: UIViewController {
    
    
    private let titleLabel:UILabel = {
        let view = UILabel()
        view.text = "TEsting232132"
        return view
    }()
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var shouldCompleteTransition = false
    private var progress: CGFloat = 0.0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        view.addSubview(titleLabel)
        view.backgroundColor = .systemBackground
        titleLabel.sizeToFit()
        titleLabel.center = view.center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let edgePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(edgePanGesture)
    }

    @objc private func handlePanGesture(_ gesture: UIScreenEdgePanGestureRecognizer) {
        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewController(animated: true)
        case .changed:
            let acc = gesture.velocity(in: view).x
            let translation = gesture.translation(in: gesture.view)
            let percent = translation.x / view.bounds.width
            progress = percent
            shouldCompleteTransition = percent + acc > 0.5
            interactionController?.update(percent)
        case .ended:
            if shouldCompleteTransition {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            interactionController?.cancel()
            interactionController = nil
        }
    }


    

}
extension DemoViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return PopTransitionAnimator()
        }
        return nil
    }
}


class PopTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: false) else {
            return
        }
        
        snapshot.frame = fromViewController.view.frame
        fromViewController.view.isHidden = true
        toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.alpha = 0
        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshot)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshot.frame = snapshot.frame.offsetBy(dx: fromViewController.view.frame.width, dy: 0)
            toViewController.view.alpha = 1
        }) { _ in
            fromViewController.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
