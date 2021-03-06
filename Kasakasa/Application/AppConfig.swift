//
//  AppConfig.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class AppConfig {

    private static var configDict: Json!
    private static var config: Config?

    static func initalize() {
        configDict = readConfigJson()
        loadRemoteConfig()
    }
    static var tipApiBaseUrl: String {
        return configDict[AppConstants.tipApiBaseUrl] as! String
    }

    static var tipApiKey: String {
        return configDict[AppConstants.tipApiKey] as! String
    }
    
    static var ethereumNetworkId: Int {
        return configDict[AppConstants.ethereumNetworkId] as! Int
    }

    static var tipContractAddress: String {
        return configDict[AppConstants.tipContractAddress] as! String
    }

    static var ethNodeUrl: String? {
        return configDict[AppConstants.ethNodeUrl] as? String
    }

    static var etherscanBaseUrl: String {
        if let url = config?.etherscanBaseUrl {
            return url
        }
        return configDict[AppConstants.etherscanBaseUrl] as! String
    }

    static var infuraAccessToken: String? {
        return configDict[AppConstants.infuraAccessToken] as? String
    }
    
    static var etherscanApiKey: String? {
        return config?.etherscanApiKey
    }

    static var ethStartBlock: String? {
        return config?.appStartBlock
    }

    static var versionNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"
    }

    static var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
    }

    static var isProduction: Bool {
        #if  ENV_DEV
            return false
        #elseif ENV_LOCAL
            return false
        #else
            return true
        #endif
    }
    
    private static var configFilename: String {
        var configFilename: String!
        #if ENV_LOCAL
        configFilename = "config.local"
        #elseif ENV_DEV
        configFilename = "config.dev"
        #else
        configFilename = "config.prod"
        #endif

        debugPrint("Config file is \(String(describing: configFilename))")
        return configFilename
    }

    private static func readConfigJson() -> Json {
        if let data = readConfigFile() {
            let json = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! Json
            debugPrint("ConfigJson = \(json)")
            return json
        }
        return [:]
    }

    private static func readConfigFile() -> Data? {
        return self.readFile(configFilename, ofType: "json")
    }

    private static func readFile(_ filename: String, ofType fileType: String) -> Data? {
        let bundle = Bundle.main
        if let filePath = bundle.path(forResource: filename, ofType: fileType) {
            let url = URL(fileURLWithPath: filePath)
            return try? Data(contentsOf: url)
        }
        return nil
    }

    private static func loadRemoteConfig() {
        let api = TipApiService.sharedInstance
        api.getAppConfig { (config, error) in
            if let config = config {
                self.config = config
            }
        }
    }
}
