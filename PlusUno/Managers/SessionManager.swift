//
//  SessionManager.swift
//  PlusUno
//
//  Created by Mario Solano on 10/23/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import Foundation

class SessionManager {
    
    static var shared = SessionManager()
    
    private let defaults = {
        return UserDefaults.standard
    }()
    
    /// Sets the level that is currently being played.
    func setCurrentLevel(_ level: Int?) {
        defaults.set(level, forKey: Defaults.currentLevel)
    }
    
    /// Retrieves the level that is currently being played.
    /// If no level is currently selected, this method returns nil.
    func currentLevel() -> Int? {
        let currentLevel = defaults.integer(forKey: Defaults.currentLevel)
        return currentLevel == 0 ? nil : currentLevel
    }
    
    /// Sets the level that was las completed.
    func setLastCompletedLevel(_ level: Int) {
        defaults.set(level, forKey: Defaults.lastCompletedLevel)
    }
    
    /// Retrieves the level that was last completed.
    /// If not level has been completed yet, then this method returns nil.
    func lastCompletedLevel() -> Int? {
        let lastCompletedLevel = defaults.integer(forKey: Defaults.lastCompletedLevel)
        return lastCompletedLevel == 0 ? nil : lastCompletedLevel
    }
    
    /// Retrieves the highest unlocked level.
    func maxLevel() -> Int {
        let level = defaults.integer(forKey: Defaults.maxLevel)
        return level == 0 ? 1 : level
    }
    
    /// Sets a new highest unlocked level.
    func unlockLevel(_ newLevel: Int) {
        let currentMaxLevel = SessionManager.shared.maxLevel()
        if newLevel > currentMaxLevel {
            defaults.set(newLevel, forKey: Defaults.maxLevel)
        }
    }
    
    /// MARK: - Sound Settings
    
    /// If current state is false, then sound is ON.
    /// If current state is true, then sound is OFF.
    func soundSettingsState() -> Bool {
        return defaults.bool(forKey: Defaults.soundState)
    }
    
    func switchSoundSettingState() -> Bool {
        let currentState = soundSettingsState()
        
        if !currentState {
            defaults.set(true, forKey: Defaults.soundState)
        } else {
            defaults.set(false, forKey: Defaults.soundState)
        }
        
        return !currentState
    }
    
    /// MARK: - Vibration Settings
    
    /// If current state is false, then sound is ON.
    /// If current state is true, then sound is OFF.
    func vibrationSettingsState() -> Bool {
        return defaults.bool(forKey: Defaults.vibrationState)
    }
    
    func switchVibrationSettingState() -> Bool {
        let currentState = vibrationSettingsState()
        
        if !currentState {
            defaults.set(true, forKey: Defaults.vibrationState)
        } else {
            defaults.set(false, forKey: Defaults.vibrationState)
        }
        
        return !currentState
    }
    
    /// MARK: - Game Center
    
    private(set) var gameCenterIsEnabled = Bool()
    
    func enableGameCenter(_ state: Bool) {
        gameCenterIsEnabled = state
    }
    
    private(set) var defaultLeaderboardID = String()
    
    func setDefaultLeaderboardID(_ name: String) {
        defaultLeaderboardID = name
    }
    
}
