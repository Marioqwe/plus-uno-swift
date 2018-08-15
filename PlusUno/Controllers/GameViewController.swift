//
//  GameViewController.swift
//  PlusUno
//
//  Created by Mario Solano on 10/21/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit
import EasyTipView

class GameViewController: PlusUnoViewController {
    
    override var name: String? {
        return "GameViewController"
    }
    
    /// The name of the view controller right above this view controller in the navigation stack.
    private var currentVC: String?
    
    var model: GameModel?
    var state: GameState?
    private let touchOperationQueue = OperationQueue()
    fileprivate var levelTipView: EasyTipView?
    fileprivate var messageTipView: EasyTipView?
    fileprivate var didShowGesturesTip: Bool = true
    
    /// The level for this game.
    var level: Int!
    
    fileprivate lazy var gameboardView: GameboardView = {
        let gameboardView = GameboardView.initWith(numRows: 3, numCols: 3)
        gameboardView.translatesAutoresizingMaskIntoConstraints = false
        /// Set this to false until the tiles are done with their new-game animation.
        gameboardView.isUserInteractionEnabled = false
        gameboardView.delegate = self
    
        return gameboardView
    }()
    
    private func setUpGameboardView() {
        view.addSubview(gameboardView)
        
        gameboardView.pinCenterY(to: view)
        gameboardView.constraintHeight(to: view, attribute: .width, multiplier: 0.85, constant: 0)
        gameboardView.constraintWidth(to: view, multiplier: 0.85, constant: 0)
        gameboardView.centerXConstraint = NSLayoutConstraint(item: gameboardView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        gameboardView.centerXConstraint.isActive = true
        
        view.layoutIfNeeded()
    }
    
    fileprivate lazy var infoBar: InfoBar = {
        let infoBar = InfoBar()
        infoBar.translatesAutoresizingMaskIntoConstraints = false
        infoBar.controller = self
        infoBar.alpha = 0.0
        
        return infoBar
    }()
    
    private func setUpInfoBar() {
        view.addSubview(infoBar)
        
        infoBar.constraintTop(to: view, attribute: .topMargin, multiplier: 1, constant: 0)
        infoBar.constraintWidth(to: view, multiplier: 1, constant: 0)
        infoBar.setHeightConstraint(to: 60)
        infoBar.pinCenterX(to: view)
        
        view.layoutIfNeeded()
    }
    
    fileprivate let tipHelperTopView: UIView = {
        return UIView.dummy()
    }()
    
    fileprivate let tipHelperGameboard: UIView = {
        return UIView.dummy()
    }()
    
    private func setupTipHelperViews() {
        view.addSubview(tipHelperTopView)
        tipHelperTopView.constraintTop(to: infoBar, attribute: .top, multiplier: 1, constant: 0)
        tipHelperTopView.constraintTrailing(to: infoBar, attribute: .trailing, multiplier: 1, constant: 0)
        tipHelperTopView.constraintHeight(to: infoBar, multiplier: 1, constant: 0)
        tipHelperTopView.constraintWidth(to: infoBar, attribute: .width, multiplier: 0.5, constant: 0)
        
        view.addSubview(tipHelperGameboard)
        tipHelperGameboard.constraintTop(to: gameboardView, attribute: .top, multiplier: 1, constant: 0)
        tipHelperGameboard.constraintWidth(to: gameboardView, attribute: .width, multiplier: 1, constant: 0)
        tipHelperGameboard.constraintTrailing(to: gameboardView, attribute: .trailing, multiplier: 1, constant: 0)
        tipHelperGameboard.constraintHeight(to: gameboardView, multiplier: 1, constant: 0)
        
        view.sendSubview(toBack: tipHelperTopView)
        view.sendSubview(toBack: tipHelperGameboard)
    }
    
    fileprivate lazy var optionsMenu: OptionsMenu = {
        let optionsMenu = OptionsMenu()
        optionsMenu.translatesAutoresizingMaskIntoConstraints = false
        optionsMenu.controller = self
        optionsMenu.isHidden = true
        
        return optionsMenu
    }()
    
    private func setUpOptionsMenu() {
        view.addSubview(optionsMenu)
        
        optionsMenu.pinCenter(to: view)
        optionsMenu.constraintHeight(to: view, attribute: .width, multiplier: 0.95, constant: 0)
        optionsMenu.constraintWidth(to: view, multiplier: 0.85, constant: 0)
        
        view.layoutIfNeeded()
    }
    
    /// Undo moves with a right swipe.
    fileprivate lazy var rightSwipeRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        recognizer.direction = .right
        
        return recognizer
    }()
    
    /// Undo moves with a left swipe.
    fileprivate lazy var leftSwipeRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        recognizer.direction = .left
        
        return recognizer
    }()
    
    /// Open menu with double tap.
    fileprivate lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        recognizer.numberOfTapsRequired = 2
        
        return recognizer
    }()
    
    override func viewDidLoad() {
        SoundManager.playSound(name: "Puzzle-Game-3", isAmbient: true)
        super.viewDidLoad()
        
        setupNotificationObservers()
        
        /// Setup subviews.
        setUpGameboardView()
        setUpInfoBar()
        setUpOptionsMenu()
        setupTipHelperViews()
        
        /// Start game.
        startGame(forLevel: level)
        
        /// Add gestures recognizers.
        view.addGestureRecognizer(rightSwipeRecognizer)
        view.addGestureRecognizer(leftSwipeRecognizer)
        view.addGestureRecognizer(doubleTapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentVC != nil {
            if currentVC! == "SettingsViewController" {
                /// Coming back from settings view controller.
                optionsMenu.animateEntrance()
            } else if currentVC! == "AdMob" {
                /// Coming back from interstitial ad.
                navigationController?.popViewController(animated: false)
            }
            return
        } else {
            showGesturesTip()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    /// MARK: - Private Helpers
    
    @objc private func handleTermination() {
        model?.saveState()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTermination), name: .UIApplicationWillTerminate, object: nil)
    }
    
    private func showGesturesTip() {
        guard UserDefaults.standard.bool(forKey: "doNotShowTip") == false else { return }
        let alertVC = PMAlertController(title: localizedString("GESTURES_TIP_TITLE"), description: localizedString("GESTURES_TIP"), image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: localizedString("GOT_IT"), style: .default, action: nil))
        alertVC.addAction(PMAlertAction(title: localizedString("DISMISS"), style: .cancel, action: {
            UserDefaults.standard.set(true, forKey: "doNotShowTip")
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func startGame(forLevel level: Int) {
        model = GameModel.normalMode(level: level, delegate: self, withState: state)
        infoBar.setLevel(level)
    }
    
    fileprivate func showTip(text: String, forView viewForTip: UIView, arrowPosition position: EasyTipView.ArrowPosition = .top) -> EasyTipView {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "JosefinSans", size: 20)!
        preferences.drawing.foregroundColor = Theme.tintColor
        preferences.drawing.backgroundColor = UIColor.white
        preferences.drawing.arrowPosition = position
        preferences.drawing.borderColor = Theme.tintColor
        preferences.drawing.borderWidth = 1
        
        let tipView = EasyTipView(text: text, preferences: preferences, delegate: self)
        tipView.show(forView: viewForTip, withinSuperview: view)
        
        return tipView
    }
    
}

/// MARK: - GameboardViewDelegate
extension GameViewController: GameboardViewDelegate {
    
    func didTouchTile(at indexPath: IndexPath) {
        messageTipView?.dismiss()
        let performTouchOperation = BlockOperation()
        performTouchOperation.addExecutionBlock { [weak self, unowned performTouchOperation] in
            guard !performTouchOperation.isCancelled else { return }
            OperationQueue.main.addOperation {
                let position = (indexPath.row, indexPath.section)
                self?.model?.didTouchTile(at: position)
            }
        }
        
        touchOperationQueue.addOperation(performTouchOperation)
    }
    
}

/// MARK: - OptionsMenu Callbacks.
extension GameViewController {
    
    func resumeGame() {
        optionsMenu.animateExit {
            /// on completion
            self.optionsMenu.isHidden = true
            self.gameboardView.centerXConstraint.constant -= self.view.bounds.width
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                self.infoBar.isHidden = false
            }, completion: { _ in
                self.rightSwipeRecognizer.isEnabled = false
                self.leftSwipeRecognizer.isEnabled = true
                self.doubleTapRecognizer.isEnabled = true
            })
        }
    }
    
    func resetGame() {
        model?.resetGame()
        resumeGame()
    }
    
    func backToLevelsMenu() {
        optionsMenu.animateExit {
            SoundManager.pauseAllSounds()
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func openSettings() {
        optionsMenu.animateExit {
            let settingsVC = SettingsViewController()
            self.currentVC = settingsVC.name
            self.navigationController?.pushViewController(settingsVC, animated: false)
        }
    }
    
}

/// MARK: - UIGestureRecognizer Selectors
extension GameViewController {
    
    @objc fileprivate func didDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        guard !gameboardView.frame.contains(touchPoint) else { return }
        
        touchOperationQueue.cancelAllOperations()
        
        model?.saveState()
        rightSwipeRecognizer.isEnabled = false
        leftSwipeRecognizer.isEnabled = false
        doubleTapRecognizer.isEnabled = false
        
        levelTipView?.dismiss()
        messageTipView?.dismiss()
        
        gameboardView.centerXConstraint.constant += view.bounds.width
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.infoBar.isHidden = true
        }) { _ in
            self.optionsMenu.isHidden = false
            self.optionsMenu.animateEntrance()
        }
    }
    
    @objc fileprivate func didSwipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        touchOperationQueue.cancelAllOperations()
        model?.undoMove()
    }
    
}

/// MARK: - GameModelDelegate
extension GameViewController: GameModelDelegate {
    
    func gameModel(_ model: GameModel, didStartNewGameWithLevel level: Int) {
        /// Set this flag to true so that tiles start using a pop-type animation.
        gameboardView.didDrawTiles = true
        SoundManager.playSound(name: "digi_pulse_hi")
        
        /// Allow the user to start playing.
        gameboardView.isUserInteractionEnabled = true
        infoBar.alpha = 1.0
        
        levelTipView?.dismiss()
        messageTipView?.dismiss()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            self.levelTipView = self.showTip(text: localizedString("LEVELS_TIP") + "\(level)", forView: self.tipHelperTopView)
        }
    }
    
    func gameModel(_ model: GameModel, didSelectTilesAt positions: [(Int, Int)], _ flag: Bool) {
        for (row, col) in positions {
            let indexPath = IndexPath(row: row, section: col)
            gameboardView.selectTile(at: indexPath, flag)
            flag ? SoundManager.playSound(name: "digi_plink") : SoundManager.playSound(name: "digi_powerdown")
        }
    }
    
    func gameModel(_ model: GameModel, didSendInvalidMoveMessage message: String) {
        levelTipView?.dismiss()
        messageTipView?.dismiss()
        messageTipView = showTip(text: message, forView: tipHelperGameboard, arrowPosition: .bottom)
    }
    
    func gameModel(_ model: GameModel, didInsertTilesAt positions: [(Int, Int)], withValues values: [Int]) {
        for ((row, col), val) in zip(positions, values) {
            let indexPath = IndexPath(row: row, section: col)
            gameboardView.insertTile(at: indexPath, withValue: val)
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
    
    func gameModel(_ model: GameModel, didUndoMoveAt positions: [(Int, Int)], withValues values: [Int]) {
        for ((row, col), val) in zip(positions, values) {
            let indexPath = IndexPath(row: row, section: col)
            gameboardView.insertTile(at: indexPath, withValue: val)
        }
        SoundManager.playSound(name: "digi_pulse_lo")
    }
    
    func gameModel(_ model: GameModel, didUpdateNumberOfMovesTo value: Int) {
        infoBar.setMoves(value)
    }

    func gameModel(_ model: GameModel, didResetLevel level: Int) {
        gameboardView.resetAllTileValues()
    }
    
    func gameModel(_ model: GameModel, didCompleteLevel level: Int, withTotalMoves moves: Int) {
        /// Disable interactions so as to not mess up the animations.
        gameboardView.isUserInteractionEnabled = false
        view.removeGestureRecognizer(rightSwipeRecognizer)
        view.removeGestureRecognizer(leftSwipeRecognizer)
        view.removeGestureRecognizer(doubleTapRecognizer)
        
        levelTipView?.dismiss()
        messageTipView?.dismiss()
        
        SoundManager.playSound(name: "digi_chime_echo")
        SoundManager.vibrate()
        
        GameCenterManager.postBestScore(level)
        
        UIView.animate(withDuration: 0.5) {
            self.infoBar.alpha = 0.0
            self.gameboardView.removeAllTiles {
                /// On completion.
                SessionManager.shared.setLastCompletedLevel(level)
                SessionManager.shared.unlockLevel(level + 1)
                SoundManager.pauseAllSounds()

                if RootViewController.shared.interstitial.isReady && SessionManager.shared.maxLevel() > adMobThreshold() {
                    self.currentVC = "AdMob"
                    RootViewController.shared.interstitial.present(fromRootViewController: self)
                } else {
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
    }
    
}

/// MARK: - EasyTipViewDelegate
extension GameViewController: EasyTipViewDelegate {
    
    func easyTipViewDidDismiss(_ tipView: EasyTipView) {}
    
}
