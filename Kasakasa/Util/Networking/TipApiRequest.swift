//
//  TipNetworkRequest.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit

enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PATCH
    case PUT
    case OPTIONS
    case HEAD
}

typealias Parameters = [String: String]

enum TipApiRequest {

    private var multipartBoundary: String {
        return "XXX"
    }

    //TODO: Implement secure authorization
    case authorize(message: SecureMessage)
    case getConfig
    case getCountries
    case getCountry(code: String)
    case startPhoneVerification(verification: PhoneVerificationRequest)
    case checkPhoneVerification(verification: PhoneVerificationRequest)

    case checkUsername(_ username: String)
    case createAccount(user: User, signupToken: String, claimDemoAccount: Bool)
    case getMyAccount
    case uploadPhoto(photo: UIImage)

    case contactList
    case addContact(_ contact: ContactRequest)
    case addContacts(_ contacts: ContactListRequest)
    case searchByUsername(_ query: String)
    case deleteContact(_ contact: ContactRequest)
    case postTransaction(_ transaction: Transaction)
    case getTransactions(params: Parameters)
    case fillTransactions(txList: [Transaction])

    var baseUrl: URL {
        return URL(string: AppConfig.tipApiBaseUrl)!
    }

    var contentType: String {
        switch self {
        case .uploadPhoto:
            return "multipart/form-data; boundary=\(multipartBoundary)"
        default:
            return "application/json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .authorize, .startPhoneVerification, .checkPhoneVerification, .createAccount, .uploadPhoto, .addContact, .addContacts, .postTransaction, .fillTransactions:
            return .POST
        case .deleteContact:
            return .DELETE
        default:
            return .GET
        }
    }

    var headers: [String: String] {
        switch self {
        case .createAccount(_, let signupToken, let claimDemoAccount):
            return ["x-signup-token": signupToken, "x-claim-demo-account": String(claimDemoAccount)]
        case .getConfig:
            return ["x-tip-platform": "ios", "x-tip-api-key": AppConfig.tipApiKey]
        default:
            return [:]
        }
    }

    var jsonBody: Json? {
        switch self {
        case .authorize(let message):
            return message.dictionary()
        case .startPhoneVerification(let verification), .checkPhoneVerification(let verification):
            return verification.dictionary()
        case .createAccount(let user, _, _):
            return user.dictionary()
        case .addContact(let contact):
            return contact.dictionary()
        case .addContacts(let contacts):
            return contacts.dictionary()
        case .postTransaction(let transaction):
            return transaction.dictionary()
        case .fillTransactions(let txList):
            let jsonArray = txList.map { (t) -> Json in
                return t.dictionary() ?? [:]
            }
            return ["transactions": jsonArray]
        default:
            return nil
        }
    }

    var httpBody: Data? {
        switch self {
        case .authorize, .startPhoneVerification, .checkPhoneVerification, .createAccount, .addContact, .addContacts:
            if let jsonBody = self.jsonBody, let data = try? JSONSerialization.data(withJSONObject: jsonBody, options: .prettyPrinted) {
                return data
            }
        case .fillTransactions:
            if let jsonBody = self.jsonBody, let transactions = jsonBody["transactions"], let data = try? JSONSerialization.data(withJSONObject: transactions, options: .prettyPrinted) {
                return data
            }
        case .uploadPhoto(let photo):
            if let imageData = photo.jpegData(compressionQuality: 0.9) {
                let multipartData = self.multipartFormData(data: imageData, boundary: multipartBoundary, fileName: "file")
                return multipartData
            }
        default:
            return nil
        }
        return nil
    }

    var queryParams: Parameters {
        switch self {
        case .checkUsername(let username), .searchByUsername(let username):
            return ["username": username]
        default:
            return [:]
        }
    }

    var url: URL {
        switch self {
        case .authorize:
            return baseUrl.appendingPathComponent("/secure/authorize")
        case .getConfig:
            return baseUrl.appendingPathComponent("/appconfig")
        case .getCountries:
            return baseUrl.appendingPathComponent("/countries")
        case .getCountry(let code):
            return baseUrl.appendingPathComponent("/countries/\(code)")
        case .startPhoneVerification:
            return baseUrl.appendingPathComponent("/phones/verificationStart")
        case .checkPhoneVerification:
            return baseUrl.appendingPathComponent("/phones/verificationCheck")
        case .checkUsername:
            return baseUrl.appendingPathComponent("/accounts/check")
        case .createAccount:
            return baseUrl.appendingPathComponent("/secure/identity")
        case .getMyAccount:
            return baseUrl.appendingPathComponent("/accounts/my")
        case .uploadPhoto:
            return baseUrl.appendingPathComponent("/accounts/photos")
        case .contactList, .addContact, .deleteContact:
            return baseUrl.appendingPathComponent("/contacts")
        case .addContacts:
            return baseUrl.appendingPathComponent("/contacts/multiple")
        case .searchByUsername:
            return baseUrl.appendingPathComponent("/accounts/search")
        case .getTransactions, .postTransaction:
            return baseUrl.appendingPathComponent("/transactions")
        case .fillTransactions:
            return baseUrl.appendingPathComponent("/transactions/fill")
        }
    }
}

extension TipApiRequest: UrlRequestConvertible {

    func toUrlRequest() -> URLRequest {
        let url = self.url

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !self.queryParams.isEmpty {
            urlComponents!.queryItems = [URLQueryItem]()
            for (key, value) in queryParams {
                let queryItem = URLQueryItem(name: key, value: value)
                urlComponents?.queryItems?.append(queryItem)
            }
            let escapedComponents = urlComponents?.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            urlComponents?.percentEncodedQuery = escapedComponents
        }

        let request = NSMutableURLRequest(url: urlComponents!.url!)
        request.httpMethod = self.method.rawValue
        if request.allHTTPHeaderFields == nil {
            request.allHTTPHeaderFields = [:]
        }
        let headers = request.allHTTPHeaderFields?.merging(self.headers, uniquingKeysWith: { (first, _) -> String in
            first
        })
        request.allHTTPHeaderFields = headers

        if let httpBody = self.httpBody {
            request.httpBody = httpBody
            request.addValue(self.contentType, forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }

        return request as URLRequest
    }

    // 
    private func multipartFormData(data: Data, boundary: String, fileName: String) -> Data {
        var fullData = Data()

        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"file\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        // 4
        fullData.append(data as Data)

        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)

        return fullData
    }
}
