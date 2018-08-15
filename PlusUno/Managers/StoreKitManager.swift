//
//  StoreKitManager.swift
//  PlusUno
//
//  Created by Mario Solano on 3/14/18.
//  Copyright © 2018 Mario Solano. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewManager {
    
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        guard var appOpenCount = UserDefaults.standard.value(forKey: Defaults.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: Defaults.APP_OPENED_COUNT)
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: Defaults.APP_OPENED_COUNT)
    }
    
    static func checkAndAskForReview() { // call this whenever appropriate
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        guard let appOpenCount = UserDefaults.standard.value(forKey: Defaults.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: Defaults.APP_OPENED_COUNT)
            return
        }
        
        switch appOpenCount {
        case _ where appOpenCount % 10 == 0 :
            StoreReviewManager.requestReview()
        default:
            break;
        }
    }
    
    static fileprivate func requestReview() {
        SKStoreReviewController.requestReview()
    }
    
}
