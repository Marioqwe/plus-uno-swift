//
//  OptionsMenu.swift
//  PlusUno
//
//  Created by Mario Solano on 10/28/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class OptionsMenu: UIView {

    var controller: GameViewController?
    private var didDrawSubviews = false
    
    /// MARK: - Reset Button
    
    private let resetButton: OptionsButton = {
        let button = OptionsButton()
        button.title = localizedString("RESET")
        
        return button
    }()
    
    private func setUpResetButton() {
        addSubview(resetButton)
        resetButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        resetButton.constraintWidth(to: self, multiplier: 0.9, constant: 0)
        resetButton.constraintHeight(to: self, multiplier: 0.16, constant: 0)
        resetButton.pinCenterY(to: self)
        resetButton.centerXConstraint = NSLayoutConstraint(item: resetButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        resetButton.centerXConstraint?.isActive = true
    }
    
    /// MARK: - Resume Button
    
    private let resumeButton: OptionsButton = {
        let button = OptionsButton()
        button.title = localizedString("RESUME")
        
        return button
    }()
    
    private func setUpResumeButton() {
        addSubview(resumeButton)
        resumeButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        resumeButton.constraintWidth(to: self, multiplier: 0.9, constant: 0)
        resumeButton.constraintHeight(to: self, multiplier: 0.16, constant: 0)
        resumeButton.constraintBottom(to: resetButton, attribute: .top, multiplier: 1, constant: -32)
        resumeButton.centerXConstraint = NSLayoutConstraint(item: resumeButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        resumeButton.centerXConstraint?.isActive = true
    }
    
    /// MARK: - Menu Button
    
    private let menuButton: OptionsButton = {
        let button = OptionsButton()
        button.title = localizedString("LEVELS_MENU")
        
        return button
    }()
    
    private func setUpMenuButton() {
        addSubview(menuButton)
        menuButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        menuButton.constraintWidth(to: self, multiplier: 0.9, constant: 0)
        menuButton.constraintHeight(to: self, multiplier: 0.16, constant: 0)
        menuButton.constraintTop(to: resetButton, attribute: .bottom, multiplier: 1, constant: 32)
        menuButton.centerXConstraint = NSLayoutConstraint(item: menuButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        menuButton.centerXConstraint?.isActive = true
    }
    
    /// MARK: - Settings Button
    
    private var settingsButtonCenterXConstraint: NSLayoutConstraint?
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "ic_settings")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = Theme.tintColor
        
        return button
    }()
    
    private func setUpSettingsButton() {
        addSubview(settingsButton)
        settingsButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        settingsButtonCenterXConstraint = NSLayoutConstraint(item: settingsButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        settingsButtonCenterXConstraint?.isActive = true
        settingsButton.setWidthConstraint(to: 40)
        settingsButton.setHeightConstraint(to: 40)
        settingsButton.constraintTop(to: menuButton, attribute: .bottom, multiplier: 1, constant: 16)
    }
    
    /// MARK: - Button Actions
    
    @objc private func didTapButton(_ button: UIButton) {
        if let title = button.titleLabel?.text {
            SoundManager.playSound(name: "digi_plink")
            switch title {
            case localizedString("RESUME"):
                controller?.resumeGame()
            case localizedString("RESET"):
                controller?.resetGame()
            case localizedString("LEVELS_MENU"):
                controller?.backToLevelsMenu()
            default:
                /// Should not happen.
                break
            }
        } else {
            SoundManager.playSound(name: "digi_plink")
            controller?.openSettings()
        }
    }
    
    /// MARK: - Animations
    
    func animateEntrance() {
        resumeButton.centerXConstraint?.constant = 0
        resumeButton.animateBounceFromLeft(withDuration: 0.3, delay: 0)
        
        resetButton.centerXConstraint?.constant = 0
        resetButton.animateBounceFromLeft(withDuration: 0.3, delay: 0.1)
        
        menuButton.centerXConstraint?.constant = 0
        menuButton.animateBounceFromLeft(withDuration: 0.3, delay: 0.2)

        settingsButtonCenterXConstraint?.constant = 0
        settingsButton.animateBounceFromLeft(withDuration: 0.3, delay: 0.3)
    }
    
    func animateExit(_ completion: (() -> Void)?) {
        resumeButton.animateExitLeft(withDuration: 0.3, delay: 0, completion: {
            self.resumeButton.centerXConstraint?.constant = -UIScreen.main.bounds.width
            self.layoutIfNeeded()
        })
        
        resetButton.animateExitLeft(withDuration: 0.3, delay: 0.1, completion: {
            self.resetButton.centerXConstraint?.constant = -UIScreen.main.bounds.width
            self.layoutIfNeeded()
        })
        
        menuButton.animateExitLeft(withDuration: 0.3, delay: 0.2, completion: {
            self.menuButton.centerXConstraint?.constant = -UIScreen.main.bounds.width
            self.layoutIfNeeded()
        })
        
        settingsButton.animateExitLeft(withDuration: 0.3, delay: 0.3, completion: {
            self.settingsButtonCenterXConstraint?.constant = -UIScreen.main.bounds.width
            self.layoutIfNeeded()
            completion?()
        })
    }
    
    /// MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didDrawSubviews {
            setUpResetButton()
            setUpResumeButton()
            setUpMenuButton()
            setUpSettingsButton()
            didDrawSubviews = true
        }
    }
    
}
