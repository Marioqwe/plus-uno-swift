//
//  LeaderboardViewController.swift
//  PlusUno
//
//  Created by Mario Solano on 11/7/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit
import GameKit

class LeaderboardViewController: PlusUnoViewController {
    
    override var name: String? {
        return "LeaderboardViewController"
    }

    /// MARK: - UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        present(GameCenterManager.newViewController(withDelegate: self), animated: true, completion: nil)
    }
    
}

/// MARK: - GKGameCenterControllerDelegate
extension LeaderboardViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: false)
    }
    
}
