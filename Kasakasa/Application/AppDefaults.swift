//
//  DefaultsManager.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

class AppDefaults: NSObject {

    static var shared = AppDefaults()
    
    private let defaultsSuiteName = "io.tipblockchain.kasakasa"
    private lazy var defaults = UserDefaults(suiteName: defaultsSuiteName)

    private let kOnboardingComplete = "onboarding_complete"
    private let kPendingSignupToken = "pending_signup_token"
    private let kCurrentUser = "current_user"
    private let kDemoAccountUser = "demo_account_user"
    private let kAuthorization = "authorization"
    private let kWalletLastCurrency = "wallet_last_currency"
    private let kShouldPromptPasswordForTransactions = "should_prompt_password_transactions"
    private let kShouldPromptPasswordForRecoveryPhrase = "should_prompt_password_recovery_phrase"
    private let kPrefernecesInitializedKey = "preferences_initialized"

    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()

    private override init() {
    }

    func initialize() {
        if !self.preferencesInitialized {
            self.shouldPromptPasswordForTransactions = true
            self.shouldPromptPasswordForRecoveryPhrase = true
            self.preferencesInitialized = true
        }
    }

    var onboardingComplete: Bool {
        get {
            return defaults?.bool(forKey: kOnboardingComplete) ?? false
        }
        set(value) {
            defaults?.set(value, forKey: kOnboardingComplete)
            defaults?.synchronize()
        }
    }

    var currentUser: User? {
        get {
            if let userData = defaults?.object(forKey: kCurrentUser) as? Data, let user = try? decoder.decode(User.self, from: userData) {
                return user
            }
            return nil
        }
        set {
            guard newValue != nil else {
                defaults?.removeObject(forKey: kCurrentUser)
                return
            }
            if let data = try? encoder.encode(newValue) {
                defaults?.set(data, forKey: kCurrentUser)
            }
        }
    }

    var demoAccountUser: User? {
        get {
            if let userData = defaults?.object(forKey: kDemoAccountUser) as? Data, let user = try? decoder.decode(User.self, from: userData) {
                return user
            }
            return nil
        }
        set {
            guard newValue != nil else {
                defaults?.removeObject(forKey: kDemoAccountUser)
                return
            }
            if let data = try? encoder.encode(newValue) {
                defaults?.set(data, forKey: kDemoAccountUser)
            }
        }
    }

    var pendingSignupToken: String? {
        get {
            return defaults?.string(forKey: kPendingSignupToken)
        }
        set {
            defaults?.set(newValue, forKey: kPendingSignupToken)
            defaults?.synchronize()
        }
    }

    var authorization: Authorization? {
        get {
            if let userData = defaults?.object(forKey: kAuthorization) as? Data,
                let authorization = try? decoder.decode(Authorization.self, from: userData) {
                return authorization
            }
            return nil
        }
        set {
            guard newValue != nil else {
                defaults?.removeObject(forKey: kAuthorization)
                return
            }
            if let data = try? encoder.encode(newValue) {
                defaults?.set(data, forKey: kAuthorization)
            }
        }
    }

    var preferencesInitialized: Bool {
        get {
            return defaults?.bool(forKey: kPrefernecesInitializedKey) ?? false
        }

        set {
            defaults?.set(newValue, forKey: kPrefernecesInitializedKey)
        }
    }

    var shouldPromptPasswordForRecoveryPhrase: Bool {
        get {
            return defaults?.bool(forKey: kShouldPromptPasswordForRecoveryPhrase) ?? true
        }

        set {
            defaults?.set(newValue, forKey: kShouldPromptPasswordForRecoveryPhrase)
        }
    }

    var shouldPromptPasswordForTransactions: Bool {
        get {
            return defaults?.bool(forKey: kShouldPromptPasswordForTransactions) ?? true
        }

        set {
            defaults?.set(newValue, forKey: kShouldPromptPasswordForTransactions)
        }
    }

    func save() {
        defaults?.synchronize()
    }

    func clear() {
        defaults?.removeSuite(named: defaultsSuiteName)
    }

}
