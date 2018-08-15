//
//  AboutViewController.swift
//  PlusUno
//
//  Created by Mario Solano on 10/29/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit
import MessageUI

class AboutViewController: PlusUnoViewController {
    
    override var name: String? {
        return "AboutViewController"
    }
    
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.controller = self.navigationController
        
        return navBar
    }()
    
    private func setUpNavbar() {
        view.addSubview(customNavBar)
        customNavBar.pinCenterX(to: view)
        customNavBar.constraintTop(to: view, attribute: .topMargin, multiplier: 1, constant: 0)
        
        customNavBar.title = localizedString("ABOUT_TITLE")
    }
    
    /// MARK: About Label
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "JosefinSans", size: 30)
        label.textColor = Theme.tintColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = localizedString("ABOUT_MESSAGE")
        
        return label
    }()
    
    private func setUpAboutLabel() {
        view.addSubview(aboutLabel)
        aboutLabel.pinCenter(to: view)
        aboutLabel.constraintHeight(to: view, multiplier: 0.35, constant: 0)
        aboutLabel.constraintWidth(to: view, multiplier: 0.8, constant: 0)

        customNavBar.onBackButtonTapped.append {
            self.aboutLabel.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
            self.feedbackButton.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
        }
    }
    
    /// MARK: - Send Feedback Button
    
    private let feedbackButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(localizedString("FEEDBACK"), for: .normal)
        button.titleLabel?.font = UIFont(name: "JosefinSans", size: 30)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = Theme.tintColor
        button.layer.cornerRadius = 8.5
        
        return button
    }()
    
    private func setUpFeedbackButton() {
        view.addSubview(feedbackButton)
        feedbackButton.pinCenterX(to: view)
        feedbackButton.constraintTop(to: aboutLabel, attribute: .bottom, multiplier: 1, constant: 64)
        feedbackButton.setHeightConstraint(to: 60)
        feedbackButton.setWidthConstraint(to: 210)
        feedbackButton.addTarget(self, action: #selector(didTapFeedbackButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didTapFeedbackButton(_ sender: UIButton) {
        SoundManager.playSound(name: "digi_plink")
        let emailController = MFMailComposeViewController()
        emailController.mailComposeDelegate = self
        emailController.setToRecipients(["mari09w3@gmail.com"])
        emailController.setSubject(localizedString("FEEDBACK"))
        emailController.setMessageBody("", isHTML: false)
        animateOnViewDidAppear = false
        present(emailController, animated: true, completion: nil)
    }
    
    /// MARK: - UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavbar()
        setUpAboutLabel()
        setUpFeedbackButton()
    }
    
    var animateOnViewDidAppear: Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard animateOnViewDidAppear == true else { return }
        customNavBar.animateEntrance()
        aboutLabel.animateBounceFromRight(withDuration: AnimationConstants.entranceDuration, delay: 0)
        feedbackButton.animateBounceFromRight(withDuration: AnimationConstants.entranceDuration, delay: 0)
    }

}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
