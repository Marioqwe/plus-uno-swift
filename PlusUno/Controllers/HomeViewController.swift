//
//  HomeViewController.swift
//  PlusUno
//
//  Created by Mario Solano on 10/24/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class HomeViewController: PlusUnoViewController {
    
    override var name: String? {
        return "HomeViewController"
    }
    
    /// The name of the view controller right above this view controller in the navigation stack.
    private var currentVC: String?
    
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.controller = self.navigationController
        navBar.isBackButtonVisible = false
        
        return navBar
    }()
    
    private func setUpNavbar() {
        view.addSubview(customNavBar)
        customNavBar.pinCenterX(to: view)
        customNavBar.constraintTop(to: view, attribute: .topMargin, multiplier: 1, constant: 0)
        
        customNavBar.title = "PLUS UNO"
        customNavBar.titleFont = UIFont(name: "GillSans-UltraBold", size: 35)
    }
    
    private lazy var levelsMenu: LevelsMenu = {
        let lm = LevelsMenu()
        lm.translatesAutoresizingMaskIntoConstraints = false
        lm.controller = self
        
        return lm
    }()
    
    private func setUpLevelsMenu() {
        view.addSubview(levelsMenu)
        
        levelsMenu.constraintWidth(to: view, multiplier: 1, constant: 0)
        levelsMenu.constraintTop(to: customNavBar, attribute: .bottom, multiplier: 1, constant: 0)
        levelsMenu.pinCenter(to: view)
    }
    
    lazy var iconsBar: IconsBar = {
        let ib = IconsBar()
        ib.translatesAutoresizingMaskIntoConstraints = false
        ib.controller = self
        
        return ib
    }()
    
    private func setUpIconsBar() {
        view.addSubview(iconsBar)
        iconsBar.constraintBottom(to: view, attribute: .bottom, multiplier: 1, constant: -16)
        iconsBar.setHeightConstraint(to: 60)
        iconsBar.constraintWidth(to: view, multiplier: 1, constant: 0)
        iconsBar.pinCenterX(to: view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavbar()
        setUpIconsBar()
        setUpLevelsMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let currentVC = self.currentVC {
            if currentVC == "GameViewController" {
                animateEntranceFromGameVC()
            } else {
                animateEntranceStandard()
            }
        } else {
            animateEntranceOnFirstLoad()
        }
    }
    
    func didSelect(_ cell: UICollectionViewCell, withValue value: Int, inCollectionView collectionView: UICollectionView) {
        SessionManager.shared.setCurrentLevel(value)
        let state = CoreDataManager.fetchGameState(forLevel: value)
        
        let indexPath = collectionView.indexPath(for: cell)
        let prevCell = collectionView.cellForItem(at: IndexPath(row: indexPath!.row - 1, section: 0))
        let nextCell = collectionView.cellForItem(at: IndexPath(row: indexPath!.row + 1, section: 0))
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        let levelCell = cell as! LevelCell
        levelCell.isHidden = true
        levelCell.level = state?.getCenterTile() != nil ? state!.getCenterTile() : 0  // 0
        
        /// Flip the center cell and start the game.
        UIView.transition(with: cell, duration: 0.25, options: transitionOptions, animations: {
            cell.isHidden = true
            levelCell.isHidden = false
            /// Fade away cells not at the center, and the icons bar.
            prevCell?.alpha = 0.0
            nextCell?.alpha = 0.0
            
            self.iconsBar.animateExit()
            self.customNavBar.animateExit()
        }, completion: { _ in
            levelCell.level = value  /// back to original state.
            let gameVC = GameViewController()
            gameVC.state = state
            self.currentVC = gameVC.name
            gameVC.level = value
            prevCell?.alpha = 1.0
            nextCell?.alpha = 1.0
            self.navigationController?.pushViewController(gameVC, animated: false)
        })
        
    }
    
}

/// MARK: - IconsBar Callbacks.
extension HomeViewController {

    func showRankingPage() {
        levelsMenu.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
        customNavBar.animateExit()
        iconsBar.animateExit(completion: {
            let rankingVC = LeaderboardViewController()
            self.currentVC = rankingVC.name
            self.navigationController?.pushViewController(rankingVC, animated: false)
        })
    }
    
    func showSettingsPage() {
        levelsMenu.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
        customNavBar.animateExit()
        iconsBar.animateExit(completion: {
            let settingsVC = SettingsViewController()
            self.currentVC = settingsVC.name
            self.navigationController?.pushViewController(settingsVC, animated: false)
        })
    }
    
    func showAboutPage() {
        levelsMenu.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
        customNavBar.animateExit()
        iconsBar.animateExit(completion: {
            let aboutVC = AboutViewController()
            self.currentVC = aboutVC.name
            self.navigationController?.pushViewController(aboutVC, animated: false)
        })
    }
    
    func showTutorialPage() {
        levelsMenu.animateExitRight(withDuration: AnimationConstants.exitDuration, delay: 0)
        customNavBar.animateExit()
        iconsBar.animateExit(completion: {
            let tutorialVC = TutorialViewController()
            self.currentVC = tutorialVC.name
            self.navigationController?.pushViewController(tutorialVC, animated: false)
        })
    }
    
}

/// MARK: - Animations.
extension HomeViewController {
    
    fileprivate func animateEntranceOnFirstLoad() {
        let maxLevel = SessionManager.shared.maxLevel()
        iconsBar.animateEntrance()
        customNavBar.animateEntrance()
        levelsMenu.animateBounceFromRight(withDuration: AnimationConstants.entranceDuration, delay: 0)
        levelsMenu.scrollToFirstCell()
        levelsMenu.scrollToCell(withValue: maxLevel)
    }
    
    fileprivate func animateEntranceFromGameVC() {
        guard let currentLevel = SessionManager.shared.currentLevel() else {
            /// This should not happen since we always expect a level to be selected
            /// prior to showing a GameViewController.
            assert(false, "There should be a current level set.")
            return
        }
        
        if let lastCompletedLevel = SessionManager.shared.lastCompletedLevel() {
            if currentLevel == lastCompletedLevel {  /// Note that the 'lastCompletedLevel' should never be higher than the 'currentLevel'.
                /// User came back to menu screen after completing a level.
                SessionManager.shared.setLastCompletedLevel(0)
                
                /// Reload the levelMenu's data since a new level has been unlocked.
                levelsMenu.reloadData()
                
                /// Animations.
                levelsMenu.scrollToCell(withValue: lastCompletedLevel + 1)
                iconsBar.animateEntrance()
                customNavBar.animateEntrance()
            } else {
                /// User came back to menu screen after tapping 'back to menu'
                animateEntranceStandard()
            }
        } else {
            /// This should only happen whenever the user is not able to complete level 1.
            animateEntranceStandard()
        }
    }
    
    fileprivate func animateEntranceStandard() {
        levelsMenu.animateBounceFromRight(withDuration: 1.0, delay: 0)
        iconsBar.animateEntrance()
        customNavBar.animateEntrance()
    }
    
}
