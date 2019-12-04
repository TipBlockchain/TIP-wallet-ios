//
//  Analytics.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-12-01.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import Firebase

class AppAnalytics {

    static func logEvent(_ event: AnalyticsEvent, parameters: [String: Any]  = [:]) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
    }

    static func trackScreen(_ screenName: String, class screenClass: String) {
        Analytics.setScreenName(screenName, screenClass: screenClass)
    }
}
