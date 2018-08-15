//
//  SettingsElementView.swift
//  PlusUno
//
//  Created by Mario Solano on 11/7/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

enum SettingsState {
    case On
    case Off
}

class SettingsElementView: UIView {
    
    var onTap: (() -> Void)? = nil
    
    var currentState: SettingsState? {
        didSet {
            if currentState == .On {
                onOffLabel.text = "ON"
            } else {
                onOffLabel.text = "OFF"
            }
        }
    }
    
    var settingName: String? {
        didSet {
            if let name = settingName {
                settingLabel.text = name
            }
        }
    }
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Theme.tintColor
        
        return view
    }()
    
    private func setUpDivider() {
        addSubview(divider)
        divider.pinCenterX(to: self)
        divider.constraintWidth(to: self, multiplier: 0.85, constant: 0)
        divider.constraintBottom(to: self, attribute: .bottom, multiplier: 1, constant: 0)
        divider.setHeightConstraint(to: 1)
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func setUpContainerView() {
        addSubview(containerView)
        containerView.pinCenter(to: self)
        containerView.constraintHeight(to: self, multiplier: 0.6, constant: 0)
        containerView.constraintWidth(to: self, multiplier: 0.6, constant: 0)
    }
    
    private let settingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "JosefinSans", size: 20)
        label.textColor = Theme.tintColor
        label.textAlignment = .center
        
        return label
    }()
    
    private func setUpSettingLabel() {
        containerView.addSubview(settingLabel)
        settingLabel.pinCenterX(to: containerView)
        settingLabel.constraintHeight(to: containerView, multiplier: 0.3, constant: 0)
        settingLabel.constraintWidth(to: containerView, multiplier: 1, constant: 0)
        settingLabel.constraintTop(to: containerView, attribute: .top, multiplier: 1, constant: 0)
    }
    
    private let onOffLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "JosefinSans", size: 48)
        label.textColor = Theme.tintColor
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private func setUpOnOffLabel() {
        containerView.addSubview(onOffLabel)
        onOffLabel.pinCenterX(to: containerView)
        onOffLabel.constraintBottom(to: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        onOffLabel.constraintWidth(to: containerView, multiplier: 1, constant: 0)
        onOffLabel.constraintHeight(to: containerView, multiplier: 0.7, constant: 0)
        onOffLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
    }
    
    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        onTap?()
        SoundManager.playSound(name: "digi_plink")
    }
    
    func animateEntrance() {
        divider.animateHorizontalExpansion(withDuration: AnimationConstants.entranceDuration, delay: 0)
        containerView.animateBounceFromRight(withDuration: AnimationConstants.entranceDuration, delay: 0)
    }
    
    func animateExit() {
        divider.animateHorizontalContraction(withDuration: AnimationConstants.exitDuration, delay: 0)
        containerView.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpDivider()
        setUpContainerView()
        setUpSettingLabel()
        setUpOnOffLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
