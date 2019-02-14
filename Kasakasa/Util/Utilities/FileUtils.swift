//
//  FileUtils.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-26.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import web3swift

class FileUtils {

    private static var _walletsDirectory: URL? = nil

    static func documentsDirectoryUrl() -> URL? {
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
            return URL(fileURLWithPath: dir, isDirectory: true)
        }
        return nil
    }

    static func walletsDirectoryUrl() -> URL? {
        if let documentsDir = self.documentsDirectoryUrl() {
            let walletsDir = documentsDir.appendingPathComponent("wallets")
            debugPrint("Walletdir = \(walletsDir)")
            return walletsDir
        }
        return nil
    }

    static func databaseDirectoryUrl() -> URL? {
        if let documentsDir = self.documentsDirectoryUrl() {
            let dbDir = documentsDir.appendingPathComponent("database")
            debugPrint("database dir = \(dbDir)")
            return dbDir
        }
        return nil
    }

    static func createDatabaseDirectoryIfNotExists() throws -> Void {
        let fileManager = FileManager.default
        try fileManager.createDirectory(at: self.databaseDirectoryUrl()!, withIntermediateDirectories: true, attributes: nil)
    }

    @discardableResult
    static func createWalletDirectoryIfNotExists() throws -> Bool {
        var isDirectory: ObjCBool = false
        let filemanager = FileManager.default
        if _walletsDirectory == nil, let walletsDirUrl = self.walletsDirectoryUrl() {
            if !filemanager.fileExists(atPath: walletsDirUrl.path, isDirectory: &isDirectory) || !isDirectory.boolValue {
                try filemanager.createDirectory(at: walletsDirUrl, withIntermediateDirectories: true, attributes: nil)
                if !filemanager.fileExists(atPath: walletsDirUrl.path, isDirectory: &isDirectory) {
                    debugPrint("Unable to create wallet dir")
                    throw AppErrors.fileError
                }
                debugPrint("WalletDir created")
                return true
            }
        }
        debugPrint("WalletDir already exists")
        return false
    }

    static func filename(forKeystore keystore: BIP32Keystore) -> String? {
        if let address = keystore.addresses.first {
            let now = Date()
            let formatter = DateFormatter.keystoreFileDateFormatter
            let filename = "UTC--\(formatter.string(from: now))--\(address).json"
            return filename
        }
        return nil
    }

    static func createWalletFile(forKeystore keystore: BIP32Keystore) throws -> URL? {
        if let filename = self.filename(forKeystore: keystore), let keyData = try? keystore.serialize() {
            return try self.createWalletFile(withName: filename, contents: keyData!)
        }
        return nil
    }

    static func deleteFile(atUrl url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }

    private static func createWalletFile(withName filename: String, contents: Data) throws -> URL? {
        try self.createWalletDirectoryIfNotExists()
        if let walletsDir = self.walletsDirectoryUrl() {
            let walletFileUrl = walletsDir.appendingPathComponent(filename)
            debugPrint(("Wallet file path = \(walletFileUrl)"))
            try contents.write(to: walletFileUrl, options: Data.WritingOptions.atomicWrite)
            return walletFileUrl
        }
        return nil
    }
}
