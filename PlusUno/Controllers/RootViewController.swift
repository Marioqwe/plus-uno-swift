//
//  RootViewController.swift
//  carnell
//
//  Created by Mario Solano on 3/1/18.
//  Copyright © 2018 Mario Solano. All rights reserved.
//

import UIKit
import GameKit
import GoogleMobileAds

class RootViewController: UIViewController {
    
    /// The interstitial ad.
    var interstitial: GADInterstitial!
    
    private var currentVC: UIViewController?
    
    init() {
        currentVC = OnboardingViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        if UserDefaults.standard.bool(forKey: "notFirstLoad") == true {
            showHomeScreen()
        } else {
            UserDefaults.standard.set(true, forKey: "notFirstLoad")
        }
        
        addChildViewController(currentVC!)
        currentVC!.view.frame = view.bounds
        view.addSubview(currentVC!.view)
        currentVC!.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func flush() {
        currentVC?.willMove(toParentViewController: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParentViewController()
        currentVC = nil
    }
    
    func switchTo(viewController vc: UIViewController) {
        addChildViewController(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
        currentVC?.willMove(toParentViewController: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParentViewController()
        
        currentVC = vc
    }
    
    func showHomeScreen() {
        let navController = UINavigationController(rootViewController: HomeViewController())
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()
        switchTo(viewController: navController)
        
        DispatchQueue.global(qos: .background).async {
            GoogleAnalyticsManager.sendAnalyticsForScreen(withName: "HomeScreen")
            GameCenterManager.authenticateLocalPlayer(inViewController: self)
            self.interstitial = self.createAndLoadInterstitial()
        }
    }
    
    fileprivate func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-7387725080053261/6793204033")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
}

extension RootViewController {
    
    static let shared = RootViewController()
    
}

extension RootViewController: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
    
}
