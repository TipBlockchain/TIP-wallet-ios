//
//  AppConfig.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-04.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation

class AppConfig {

    private static var configDict: Json = readConfigJson()

    static var tipApiBaseUrl: String {
        return configDict[AppConstants.tipApiBaseUrl] as? String ?? ""
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
}
