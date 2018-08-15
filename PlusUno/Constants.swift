//
//  Constants.swift
//  PlusUno
//
//  Created by Mario Solano on 11/7/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

struct Defaults {
    static let soundState: String = "sound_state"
    static let vibrationState: String = "vibration_state"
    static let maxLevel: String = "max_level"
    static let lastCompletedLevel: String = "last_completed_level"
    static let currentLevel: String = "current_level"
    static let gameCenterState: String = "game_center_state"
    static let APP_OPENED_COUNT: String = "APP_OPENED_COUNT"
}

struct AnimationConstants {
    static let entranceDuration: TimeInterval = 0.5
    static let exitDuration: TimeInterval = 0.25
}

struct Theme {
    
    static let tintColor = UIColor(red: 65.0/255.0, green: 74.0/255.0, blue: 76.0/255.0, alpha: 1.0)
    static let backgroundColor = UIColor.white
    
}

func localizedString(_ key: String) -> String {
    return NSLocalizedString(key, tableName: "Localizable", bundle: .main, value: "", comment: "")
}

func leaderboardID() -> String {
    return "qwe.tilesApp2018"
}

func adMobThreshold() -> Int {
    return 8
}
