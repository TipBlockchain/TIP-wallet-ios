//
//  AuthorizationRepository.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-18.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class AuthorizationRepository: NSObject {

    static var shared = AuthorizationRepository()

    private override init() {}

    var currentAuthorization: Authorization? {
        get {
            return AppDefaults.sharedInstance.authorization
        }
        set {
            AppDefaults.sharedInstance.authorization = newValue
        }
    }

    func getNewAuthorization(completion: @escaping (Authorization?, AppErrors?) -> Void) {
        if let user = UserRepository.shared.currentUser {
            let secureMessage = SecureMessage(message: "", address: user.address, username: user.username, signature: "")
            TipApiService.sharedInstance.authorize(secureMessage) { (authorization, error) in
                if let authorization = authorization {
                    self.currentAuthorization = authorization
                    completion(authorization, nil)
                } else if let error = error {
                    completion(nil, error)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }
}
