//
//  TutorialViewController.swift
//  PlusUno
//
//  Created by Mario Solano on 10/29/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class TutorialViewController: PlusUnoViewController {
    
    override var name: String? {
        return "TutorialViewController"
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
        customNavBar.title = localizedString("HOW_TO_PLAY_TITLE")
        customNavBar.onBackButtonTapped = [{
            self.containerView.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
            }]
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private func setUpContainerView() {
        view.addSubview(containerView)
        containerView.constraintBottom(to: view, attribute: .bottom, multiplier: 1, constant: 0)
        containerView.constraintTop(to: customNavBar, attribute: .bottom, multiplier: 1, constant: 0)
        containerView.constraintLeading(to: view, attribute: .leading, multiplier: 1, constant: 0)
        containerView.constraintTrailing(to: view, attribute: .trailing, multiplier: 1, constant: 0)
        addOnBoardingController()
    }
    
    private func addOnBoardingController() {
        let controller = OnboardingViewController()
        controller.showLogoAndButton = false
        addChildViewController(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        
        controller.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customNavBar.animateEntrance()
        setUpContainerView()
    }
    
}
