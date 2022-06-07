//
//  FromCenterTransition.swift
//  iOS Chat
//
//  Created by Macbook on 05.05.2022.
//

import UIKit

final class FromCenterTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    private let transitionDuration: TimeInterval = 1
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FromCenterTransition()
    }
    
}

extension FromCenterTransition: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let snapshot = toVC.view.snapshotView(afterScreenUpdates: true) else { return }
        
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)
        
        snapshot.frame = CGRect(x: fromVC.view.frame.midX,
                                y: fromVC.view.frame.midY,
                                width: 0,
                                height: 0)
        
        snapshot.layer.masksToBounds = true
        
        toVC.view.frame = finalFrame
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(snapshot)
        
        toVC.view.isHidden = true
        
        snapshot.alpha = 0
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration,
                       animations: {
                        snapshot.alpha = 1.0
                        snapshot.frame = finalFrame
                       },
                       completion: { _ in
                        
                        toVC.view.isHidden = false
                        snapshot.removeFromSuperview()
                        
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                       })
    }
    
}
