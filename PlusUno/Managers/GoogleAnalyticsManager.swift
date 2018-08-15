//
//  GoogleAnalyticsManager.swift
//  PlusUno
//
//  Created by Mario Solano on 3/14/18.
//  Copyright © 2018 Mario Solano. All rights reserved.
//

import Foundation

struct GoogleAnalyticsManager {
    
    static func startTracking(withTrackingID trackingID: String) {
        guard let gai = GAI.sharedInstance() else { return }
        gai.tracker(withTrackingId: trackingID)
    }
    
    static func sendAnalyticsForScreen(withName name: String) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
}
