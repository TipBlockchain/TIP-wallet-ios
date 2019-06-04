//
//  TipApiService.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-06.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

public class TipApiService: NSObject {

    private let networkService: NetworkService = NetworkService()

    public static var sharedInstance: TipApiService = TipApiService()

    private override init() {}

    public func authorize(_ message: SecureMessage, completion: @escaping (Authorization?, AppErrors?) -> Void) {
        let request = TipApiRequest.authorize(message: message)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(Authorization.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    public func getAppConfig(_ completion: @escaping (Config?, AppErrors?) -> Void) {
        let request = TipApiRequest.getConfig
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(Config.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    //MARK:- Countries
    public func getCountries(completion: @escaping ([Country]?, AppErrors?) -> Void) {
        let request = TipApiRequest.getCountries
        
        networkService.sendRequest(request: request) { (result, error) in
            debugPrint("result = \(String(describing: result)), error = \(String(describing: error))")
            if let resultData = result as? Data, let countries: [Country] = try? JSONDecoder().decode([Country].self, from: resultData) {
                completion(countries, nil)
            } else {
                completion(nil, AppErrors.unknowkError)
            }
        }
    }

    public func getCountry(byCode code: String, completion: @escaping (Country?, AppErrors?) -> Void) {
        let request = TipApiRequest.getCountry(code: code)

        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            if let data = result as? Data, let country: Country = try? JSONDecoder().decode(Country.self, from: data) {
                completion(country, nil)
            } else {
                completion(nil, AppErrors.unknowkError)
            }
        }
    }

    // MARK: - Phone Verification
    public func startPhoneVerification(verificationRequest: PhoneVerificationRequest, completion: @escaping (PhoneVerificationResponse?, AppErrors?) -> Void) {
       let request = TipApiRequest.startPhoneVerification(verification: verificationRequest)

        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(PhoneVerificationResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    public func checkPhoneVerification(verificationRequest: PhoneVerificationRequest, completion: @escaping (PhoneVerificationResponse?, AppErrors?) -> Void) {
        let request = TipApiRequest.checkPhoneVerification(verification: verificationRequest)

        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(PhoneVerificationResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    // MARk - Accounts
    public func checkUsername(_ username: String, completion: @escaping (UsernameResponse?, AppErrors?) -> Void) {
        let request = TipApiRequest.checkUsername(username)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(UsernameResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func createAccount(user: User, signupToken: String, claimDemoAccount: Bool, completion: @escaping (User?, AppErrors?) -> Void) {
        let request = TipApiRequest.createAccount(user: user, signupToken: signupToken, claimDemoAccount: claimDemoAccount)

        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(User.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func getMyAccount(completion: @escaping (User?, AppErrors?) -> Void) {
        let request = TipApiRequest.getMyAccount
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(User.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func uploadPhoto(_ photo: UIImage, completion: @escaping (User?, AppErrors?) -> Void) {
        let request = TipApiRequest.uploadPhoto(photo: photo)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(User.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    // MARK - Contacts

    func getContactList(completion: @escaping (ContactListResponse?, AppErrors?) -> Void) {
        let request = TipApiRequest.contactList
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(ContactListResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func search(byUsername query: String, completion: @escaping(UserSearchResponse?, AppErrors?) -> Void) {
        let request = TipApiRequest.searchByUsername(query)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(UserSearchResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func addContact(_ contact: User, completion: @escaping(ContactListStringResponse?, AppErrors?) -> Void) {
        let request = TipApiRequest.addContact(ContactRequest(contactId: contact.id))
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(ContactListStringResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func addContacts(_ contacts: [User], completion: @escaping(ContactListStringResponse?, AppErrors?) -> Void) {
        let request = TipApiRequest.addContacts(ContactListRequest(contactIds: contacts.map({ user -> String in
            user.id
        })))
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(ContactListStringResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }

    func postTransaction(_ transaction: Transaction, completion: @escaping((Transaction?, AppErrors?) -> Void)) {
        let request = TipApiRequest.postTransaction(transaction)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(Transaction.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }
    
    func getTransaction() {

    }

    func getTransactions() {

    }

    func fillTransactions(_ transactions: [Transaction], completion: @escaping((TransactionListResponse?, AppErrors?) -> Void)) {
        let request = TipApiRequest.fillTransactions(txList: transactions)
        networkService.sendRequest(request: request) { (result, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let data = result as? Data, let response = try? JSONDecoder().decode(TransactionListResponse.self, from: data) {
                    completion(response, nil)
                } else {
                    completion(nil, AppErrors.unknowkError)
                }
            }
        }
    }
}

