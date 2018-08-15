//
//  CustomNavigationBar.swift
//  PlusUno
//
//  Created by Mario Solano on 11/6/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class CustomNavigationBar: UIView {
    
    var controller: UINavigationController?
    
    /// List of callbacks to call once the back button is tapped.
    /// Ideally every item in this array is an exit animation with duration of AnimationConstants.exitDuration.
    var onBackButtonTapped: [(() -> Void)] = []  /// Note: I don't like how this is implemented but I'll just go back to this at some other point.
    
    var isBackButtonVisible: Bool = true {
        didSet {
            if isBackButtonVisible {
                backButton.isHidden = false
            } else {
                backButton.isHidden = true
            }
        }
    }
    
    private let backButton: UIImageView = {
        let button = UIImageView(image: UIImage(named: "ic_keyboard_arrow_left")?.withRenderingMode(.alwaysTemplate))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = true
        button.tintColor = Theme.tintColor
        
        return button
    }()
    
    private func setUpbackButton() {
        addSubview(backButton)
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressBackButton(_:))))
        backButton.constraintHeight(to: self, multiplier: 0.5, constant: 0)
        backButton.constraintWidth(to: self, attribute: .height, multiplier: 0.5, constant: 0)
        backButton.constraintLeading(to: self, attribute: .leading, multiplier: 1, constant: 0)
        backButton.pinCenterY(to: self)
    }
    
    @objc private func didPressBackButton(_ sender: UITapGestureRecognizer) {
        for cb in onBackButtonTapped {
            cb()
        }
        SoundManager.playSound(name: "digi_plink")
        animateExit {
            self.controller?.popViewController(animated: false)
        }
    }
    
    @objc var logoImage: UIImage? {
        didSet {
            logoImageView.image = logoImage
            logoImageView.bringSubview(toFront: self)
        }
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private func setUpLogoImageView() {
        addSubview(logoImageView)
        logoImageView.pinCenter(to: self)
        logoImageView.constraintHeight(to: self, multiplier: 0.5, constant: 0)
    }
    
    @objc var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var titleFont: UIFont? {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.tintColor
        label.font = UIFont(name: "JosefinSans", size: 30)
        
        return label
    }()
    
    private func setUpTitleLabel() {
        addSubview(titleLabel)
        titleLabel.pinCenter(to: self)
        titleLabel.constraintHeight(to: self, multiplier: 1, constant: 0)
    }
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.tintColor
        
        return view
    }()
    
    private func setUpDivider() {
        addSubview(divider)
        divider.setHeightConstraint(to: 1)
        divider.constraintWidth(to: self, multiplier: 0.85, constant: 0)
        divider.constraintBottom(to: self, attribute: .bottom, multiplier: 1, constant: 0)
        divider.pinCenterX(to: self)
    }
    
    func animateEntrance() {
        divider.animateHorizontalExpansion(withDuration: AnimationConstants.entranceDuration, delay: 0)
        titleLabel.animateBounceFromTop(withDuration: AnimationConstants.entranceDuration, delay: 0)
        logoImageView.animateBounceFromTop(withDuration: AnimationConstants.entranceDuration, delay: 0)
        backButton.animateBounceFromLeft(withDuration: AnimationConstants.entranceDuration, delay: 0)
    }
    
    func animateExit(completion: (() -> Void)? = nil) {
        divider.animateHorizontalContraction(withDuration: AnimationConstants.exitDuration, delay: 0)
        titleLabel.animateExitTop(withDuration: AnimationConstants.exitDuration, delay: 0)
        logoImageView.animateExitTop(withDuration: AnimationConstants.exitDuration, delay: 0)
        backButton.animateExitLeft(withDuration: AnimationConstants.exitDuration, delay: 0, completion: {
            completion?()
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpbackButton()
        setUpTitleLabel()
        setUpDivider()
        setUpLogoImageView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        translatesAutoresizingMaskIntoConstraints = false
        setHeightConstraint(to: UIScreen.main.bounds.height * 0.125)
        setWidthConstraint(to: UIScreen.main.bounds.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
