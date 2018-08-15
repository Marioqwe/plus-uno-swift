//
//  SettingsViewController.swift
//  PlusUno
//
//  Created by Mario Solano on 11/6/17.
//  Copyright © 2017 Mario Solano. All rights reserved.
//

import UIKit

class SettingsViewController: PlusUnoViewController {
    
    override var name: String? {
        return "SettingsViewController"
    }
    
    /// MARK: - Custom NavBar
    
    private lazy var customNavBar: CustomNavigationBar = {
        let navBar = CustomNavigationBar()
        navBar.controller = self.navigationController
        
        return navBar
    }()
    
    private func setUpNavbar() {
        view.addSubview(customNavBar)
        customNavBar.pinCenterX(to: view)
        customNavBar.constraintTop(to: view, attribute: .topMargin, multiplier: 1, constant: 0)
        customNavBar.title = localizedString("SETTINGS_TITLE")
    }
    
    /// MARK: - Sounds Settings View
    
    private let soundSettingsView: SettingsElementView = {
        let settingsView = SettingsElementView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.settingName = localizedString("SOUND")
        let state = SessionManager.shared.soundSettingsState()
        if state {
            settingsView.currentState = .Off
        } else {
            settingsView.currentState = .On
        }
        
        return settingsView
    }()
    
    private func setUpSoundSettingsView() {
        view.addSubview(soundSettingsView)
        soundSettingsView.constraintTop(to: customNavBar, attribute: .bottom, multiplier: 1, constant: 0)
        soundSettingsView.constraintWidth(to: view, multiplier: 1, constant: 0)
        soundSettingsView.pinCenterX(to: view)
        soundSettingsView.constraintHeight(to: view, multiplier: 0.3, constant: 0)
        soundSettingsView.onTap = onSoundSettingsTap
        customNavBar.onBackButtonTapped.append(soundSettingsView.animateExit)
    }
    
    private func onSoundSettingsTap() {
        let soundState = SessionManager.shared.switchSoundSettingState()
        if soundState {
            soundSettingsView.currentState = .Off
            SoundManager.pauseAllSounds()
        } else {
            soundSettingsView.currentState = .On
            SoundManager.resumeAllSounds()
        }
    }
    
    /// MARK: - Vibration Settings View
    
    private let vibrationSettingsView: SettingsElementView = {
        let settingsView = SettingsElementView()
        settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.settingName = localizedString("VIBRATION")
        let state = SessionManager.shared.vibrationSettingsState()
        if state {
            settingsView.currentState = .Off
        } else {
            settingsView.currentState = .On
        }
        
        return settingsView
    }()
    
    private func setUpVibrationSettingsView() {
        view.addSubview(vibrationSettingsView)
        vibrationSettingsView.constraintTop(to: soundSettingsView, attribute: .bottom, multiplier: 1, constant: 0)
        vibrationSettingsView.constraintWidth(to: view, multiplier: 1, constant: 0)
        vibrationSettingsView.pinCenterX(to: view)
        vibrationSettingsView.constraintHeight(to: view, multiplier: 0.3, constant: 0)
        vibrationSettingsView.onTap = onVibrationSettingsTap
        customNavBar.onBackButtonTapped.append(vibrationSettingsView.animateExit)
    }
    
    private func onVibrationSettingsTap() {
        let vibrationState = SessionManager.shared.switchVibrationSettingState()
        if vibrationState {
            vibrationSettingsView.currentState = .Off
        } else {
            vibrationSettingsView.currentState = .On
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavbar()
        setUpSoundSettingsView()
        setUpVibrationSettingsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customNavBar.animateEntrance()
        soundSettingsView.animateEntrance()
        vibrationSettingsView.animateEntrance()
    }
    
}
