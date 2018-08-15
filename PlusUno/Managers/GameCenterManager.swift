//
//  GameCenterManager.swift
//  PlusUno
//
//  Created by Mario Solano on 3/14/18.
//  Copyright © 2018 Mario Solano. All rights reserved.
//

import Foundation
import GameKit

struct GameCenterManager {
    
    static func newViewController(withDelegate delegate: GKGameCenterControllerDelegate) -> GKGameCenterViewController {
        let vc = GKGameCenterViewController()
        vc.gameCenterDelegate = delegate
        vc.viewState = .leaderboards
        vc.leaderboardIdentifier = leaderboardID()
        return vc
    }
    
    static func postBestScore(_ score: Int) {
        let bestScoreInt = GKScore(leaderboardIdentifier: leaderboardID())
        guard score > Int(bestScoreInt.value) else { return }
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt], withCompletionHandler: nil)
    }
    
    static func authenticateLocalPlayer(inViewController viewController: UIViewController) {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if ((ViewController) != nil) {
                // 1. Show login if player is not logged in
                viewController.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                SessionManager.shared.enableGameCenter(true)
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error == nil {
                        SessionManager.shared.setDefaultLeaderboardID(leaderboardIdentifer!)
                    }
                })
            } else {
                // 3. Game center is not enabled on the users device
                SessionManager.shared.enableGameCenter(false)
            }
        }
    }
    
}
