//
//  UIView_Extension.swift
//  SWIM
//
//  Created by Mario Solano on 11/1/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

extension UIView: Explodable {}

extension UIView {
    
    static func dummy() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }
    
}

extension UIView {
    
    func constraintTrailing(to view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: constant)
            ])
    }
    
    func constraintLeading(to view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: constant)
            ])
    }
    
    func constraintTop(to view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: constant)
            ])
    }
    
    func constraintBottom(to view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: constant)
            ])
    }
    
    func constraintHeight(to view: UIView, attribute: NSLayoutAttribute = .height, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: constant)
            ])
    }
    
    func setHeightConstraint(to constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute   , multiplier: 0, constant: constant)
            ])
    }
    
    func constraintWidth(to view: UIView, attribute: NSLayoutAttribute = .width, multiplier: CGFloat, constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: constant)
            ])
    }
    
    func setWidthConstraint(to constant: CGFloat) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: constant)
            ])
    }
    
    func pinCenterX(to view: UIView) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            ])
    }
    
    func pinCenterY(to view: UIView) {
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ])
    }
    
    func pinCenter(to view: UIView) {
        pinCenterX(to: view)
        pinCenterY(to: view)
    }
    
}

extension UIView {
    
    func animateExitLeft(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.transform = CGAffineTransform.init(translationX: -UIScreen.main.bounds.width, y: 0)
        }) { _ in
            self.transform = CGAffineTransform.identity
            completion?()
        }
    }
    
    func animateExitRight(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        }) { _ in
            self.transform = CGAffineTransform.identity
            completion?()
        }
    }
    
    func animateExitTop(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.transform = CGAffineTransform.init(translationX: 0, y: -UIScreen.main.bounds.width)
        }) { _ in
            self.transform = CGAffineTransform.identity
            completion?()
        }
    }
    
    func animateExitBottom(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.width)
        }) { _ in
            self.transform = CGAffineTransform.identity
            completion?()
        }
    }
    
    func animateBounceFromTop(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform.init(translationX: 0, y: -UIScreen.main.bounds.height)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            completion?()
        }
    }
    
    func animateBounceFromLeft(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform.init(translationX: -UIScreen.main.bounds.width, y: 0)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            completion?()
        }
    }
    
    func animateBounceFromBottom(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            completion?()
        }
    }
    
    func animateBounceFromRight(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            completion?()
        }
    }
    
    func animateHorizontalExpansion(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        transform = CGAffineTransform.init(scaleX: 0.01, y: 1)
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            completion?()
        }
    }
    
    func animateHorizontalContraction(withDuration duration: TimeInterval, delay: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.init(scaleX: 0.001, y: 1)
        }) { _ in
            self.transform = CGAffineTransform.identity
            completion?()
        }
    }
    
}

