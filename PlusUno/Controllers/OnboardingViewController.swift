//
//  OnboardingViewController.swift
//  PlusUno
//
//  Created by Mario Solano on 3/15/18.
//  Copyright © 2018 Mario Solano. All rights reserved.
//

import UIKit
import EasyTipView

class OnboardingViewController: UIViewController {
    
    var showLogoAndButton: Bool = true
    fileprivate var model: GameModel?
    fileprivate var numTaps: Int = 0
    fileprivate var tipView: EasyTipView?
    fileprivate var lastTip: EasyTipView?
    
    fileprivate lazy var gameboardView: GameboardView = {
        let gameboardView = GameboardView.initWith(numRows: 1, numCols: 2)
        gameboardView.translatesAutoresizingMaskIntoConstraints = false
        gameboardView.isUserInteractionEnabled = false
        gameboardView.delegate = self
        
        return gameboardView
    }()
    
    private let leftSmallView: UIView = {
        return UIView.dummy()
    }()
    
    private let rightSmallView: UIView = {
        return UIView.dummy()
    }()
    
    private let leftView: UIView = {
        return UIView.dummy()
    }()
    
    private let rightView: UIView = {
        return UIView.dummy()
    }()
    
    fileprivate let topInstructionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.tintColor
        label.font = UIFont(name: "JosefinSans", size: 26)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private let logo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "GillSans-UltraBold", size: 45)
        label.text = "PLUS UNO"
        label.textAlignment = .center
        label.textColor = Theme.tintColor
        label.isHidden = true
        
        return label
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(localizedString("MAIN_MENU"), for: .normal)
        button.titleLabel?.font = UIFont(name: "JosefinSans", size: 30)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = Theme.tintColor
        button.layer.cornerRadius = 8.5
        button.isHidden = true
        
        return button
    }()
    
    @objc private func didTapMenuButton(_ sender: UIButton) {
        SoundManager.playSound(name: "digi_plink")
        AppDelegate.shared.rootViewController.showHomeScreen()
    }
    
    private func setupViews() {
        view.addSubview(gameboardView)
        gameboardView.pinCenter(to: view)
        gameboardView.constraintWidth(to: view, multiplier: 0.6, constant: 0)
        gameboardView.constraintHeight(to: view, attribute: .width, multiplier: 0.3, constant: 0)
        view.layoutIfNeeded()
        
        view.addSubview(leftSmallView)
        leftSmallView.constraintLeading(to: gameboardView, attribute: .leading, multiplier: 1, constant: 0)
        leftSmallView.constraintHeight(to: gameboardView, multiplier: 1, constant: 0)
        leftSmallView.constraintWidth(to: gameboardView, attribute: .width, multiplier: 0.5, constant: 0)
        leftSmallView.constraintTop(to: gameboardView, attribute: .top, multiplier: 1, constant: 0)
        
        view.addSubview(rightSmallView)
        rightSmallView.constraintTrailing(to: gameboardView, attribute: .trailing, multiplier: 1, constant: 0)
        rightSmallView.constraintHeight(to: gameboardView, multiplier: 1, constant: 0)
        rightSmallView.constraintWidth(to: gameboardView, attribute: .width, multiplier: 0.5, constant: 0)
        rightSmallView.constraintTop(to: gameboardView, attribute: .top, multiplier: 1, constant: 0)
        
        view.sendSubview(toBack: rightSmallView)
        view.sendSubview(toBack: leftSmallView)
        
        view.addSubview(leftView)
        leftView.constraintLeading(to: view, attribute: .leading, multiplier: 1, constant: 0)
        leftView.constraintHeight(to: view, multiplier: 1, constant: 0)
        leftView.pinCenterY(to: view)
        leftView.constraintWidth(to: view, attribute: .width, multiplier: 0.5, constant: 0)
        
        view.addSubview(rightView)
        rightView.constraintTrailing(to: view, attribute: .trailing, multiplier: 1, constant: 0)
        rightView.constraintHeight(to: view, multiplier: 1, constant: 0)
        rightView.constraintWidth(to: view, attribute: .width, multiplier: 0.5, constant: 0)
        rightView.pinCenterY(to: view)
        
        view.addSubview(topInstructionLabel)
        topInstructionLabel.pinCenterX(to: view)
        topInstructionLabel.constraintWidth(to: view, multiplier: 0.8, constant: 0)
        topInstructionLabel.constraintHeight(to: view, multiplier: 0.4, constant: 0)
        topInstructionLabel.constraintBottom(to: gameboardView, attribute: .top, multiplier: 1, constant: 0)
        
        view.addSubview(logo)
        logo.pinCenterX(to: view)
        logo.constraintWidth(to: view, multiplier: 0.8, constant: 0)
        logo.setHeightConstraint(to: 150)
        logo.constraintBottom(to: gameboardView, attribute: .top, multiplier: 1, constant: -64)
        
        view.addSubview(menuButton)
        menuButton.pinCenterX(to: view)
        menuButton.constraintTop(to: gameboardView, attribute: .bottom, multiplier: 1, constant: 128)
        menuButton.setHeightConstraint(to: 60)
        menuButton.setWidthConstraint(to: 210)
        menuButton.addTarget(self, action: #selector(didTapMenuButton(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupViews()
        model = GameModel.genericMode(level: 100, numRows: 1, numCols: 2, values: [2, 4], delegate: self)
        gameboardView.addPulsatingAnimation(atIndexPath: IndexPath(row: 0, section: 0))
        view.sendSubview(toBack: leftView)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self.tipView = self.showTip(text: localizedString("SECOND_INSTRUCTIONS"), forView: self.leftSmallView, arrowPosition: .top)
        }
    }
    
    fileprivate func showTip(text: String, forView viewForTip: UIView, arrowPosition position: EasyTipView.ArrowPosition = .top) -> EasyTipView {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "JosefinSans", size: 26)!
        preferences.drawing.foregroundColor = Theme.tintColor
        preferences.drawing.backgroundColor = UIColor.white
        preferences.drawing.arrowPosition = position
        preferences.drawing.borderColor = Theme.tintColor
        preferences.drawing.borderWidth = 1
        
        let tipView = EasyTipView(text: text, preferences: preferences)
        tipView.show(forView: viewForTip, withinSuperview: view)
        
        return tipView
    }
    
    fileprivate func showLogoAndMenuButton() {
        UIView.animate(withDuration: 0.5, animations: {
            self.topInstructionLabel.alpha = 0.0
        }) { _ in
            self.logo.isHidden = false
            self.logo.animateBounceFromTop(withDuration: 0.5, delay: 0)
            
            self.menuButton.isHidden = false
            self.menuButton.animateBounceFromRight(withDuration: 0.5, delay: 0)
        }
    }
}

/// MARK: GameboardViewDelegate
extension OnboardingViewController: GameboardViewDelegate {
    
    func didTouchTile(at indexPath: IndexPath) {
        let position = (indexPath.row, indexPath.section)
        model?.didTouchTile(at: position)
        gameboardView.removePulsatingAnimation(atIndexPath: indexPath)
        
        numTaps += 1
        
        switch numTaps {
        case 1:
            view.bringSubview(toFront: leftView)
            view.sendSubview(toBack: rightView)
            gameboardView.addPulsatingAnimation(atIndexPath: IndexPath(row: 0, section: 1))
            tipView?.dismiss()
            tipView = showTip(text: localizedString("SECOND_INSTRUCTIONS"), forView: rightSmallView, arrowPosition: .top)
        case 2:
            view.bringSubview(toFront: rightView)
            view.sendSubview(toBack: leftView)
            gameboardView.addPulsatingAnimation(atIndexPath: IndexPath(row: 0, section: 0))
            tipView?.dismiss()
            tipView = showTip(text: localizedString("THIRD_INSTRUCTIONS"), forView: leftSmallView, arrowPosition: .top)
        case 3:
            view.bringSubview(toFront: leftView)
            view.sendSubview(toBack: rightView)
            gameboardView.addPulsatingAnimation(atIndexPath: IndexPath(row: 0, section: 1))
            tipView?.dismiss()
            tipView = showTip(text: localizedString("FOURTH_INSTRUCTIONS"), forView: rightSmallView, arrowPosition: .top)
        case 4:
            view.bringSubview(toFront: rightView)
            view.sendSubview(toBack: leftView)
            gameboardView.addPulsatingAnimation(atIndexPath: IndexPath(row: 0, section: 0))
            tipView?.dismiss()
            tipView = showTip(text: localizedString("FIFTH_INSTRUCTIONS"), forView: leftSmallView, arrowPosition: .top)
        case 5:
            view.bringSubview(toFront: leftView)
            view.sendSubview(toBack: rightView)
            gameboardView.addPulsatingAnimation(atIndexPath: IndexPath(row: 0, section: 1))
            tipView?.dismiss()
            tipView = showTip(text: localizedString("SIXTH_INSTRUCTIONS"), forView: rightSmallView, arrowPosition: .top)
            lastTip = showTip(text: localizedString("SEVENTH_INSTRUCTIONS"), forView: leftSmallView, arrowPosition: .bottom)
        case 6:
            view.sendSubview(toBack: leftView)
            lastTip?.dismiss()
            tipView?.dismiss()
            
            topInstructionLabel.alpha = 0
            topInstructionLabel.isHidden = false
            topInstructionLabel.transform = CGAffineTransform.init(scaleX: 0.2, y: 0.2)
            if showLogoAndButton {
                topInstructionLabel.text = localizedString("TOP_INSTRUCTIONS")
            } else {
                topInstructionLabel.text = localizedString("TOP_INSTRUCTIONS_TUTORIAL")
            }
            UIView.animate(withDuration: 0.25, animations: {
                self.topInstructionLabel.transform = CGAffineTransform.identity
                self.topInstructionLabel.alpha = 1
            }, completion: nil)
        case 10:
            if showLogoAndButton {
                showLogoAndMenuButton()
            }
        default:
            break
        }
    }
    
}

/// MARK: - GameModelDelegate
extension OnboardingViewController: GameModelDelegate {
    
    func gameModel(_ model: GameModel, didStartNewGameWithLevel level: Int) {
        gameboardView.didDrawTiles = true
        gameboardView.isUserInteractionEnabled = true
    }
    
    func gameModel(_ model: GameModel, didSelectTilesAt positions: [(Int, Int)], _ flag: Bool) {
        for (row, col) in positions {
            let indexPath = IndexPath(row: row, section: col)
            gameboardView.selectTile(at: indexPath, flag)
            if flag {
                SoundManager.playSound(name: "digi_plink")
            } else {
                SoundManager.playSound(name: "digi_powerdown")
            }
        }
    }
    
    func gameModel(_ model: GameModel, didInsertTilesAt positions: [(Int, Int)], withValues values: [Int]) {
        for ((row, col), val) in zip(positions, values) {
            let indexPath = IndexPath(row: row, section: col)
            gameboardView.insertTile(at: indexPath, withValue: val)
            gameboardView.setColor(UIColor.lightGray, forTileAtIndexPath: indexPath)
        }
        
        guard gameboardView.didDrawTiles else { return }
        SoundManager.playSound(name: "digi_pulse_hi")
    }
    
    func gameModel(_ model: GameModel, didRemoveTilesAt positions: [(Int, Int)]) {
        for (row, col) in positions {
            let indexPath = IndexPath(row: row, section: col)
            gameboardView.removeTile(from: indexPath)
        }
    }
    
    /// These methods are not used.
    /// They could be made optional but I will tackle that at some other point.
    
    func gameModel(_ model: GameModel, didUndoMoveAt positions: [(Int, Int)], withValues values: [Int]) {}
    
    func gameModel(_ model: GameModel, didUpdateNumberOfMovesTo value: Int) {}
    
    func gameModel(_ model: GameModel, didResetLevel level: Int) {}
    
    func gameModel(_ model: GameModel, didCompleteLevel level: Int, withTotalMoves moves: Int) {}
    
    func gameModel(_ model: GameModel, didSendInvalidMoveMessage message: String) {}
    
}
