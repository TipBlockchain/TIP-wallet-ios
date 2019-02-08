//
//  AppDatabase.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-02-01.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import Foundation
import GRDB

class AppDatabase {

    static var dbPool: DatabasePool!

    static func openDatabase(atPath path: String) throws -> DatabasePool {
        let dbPool = try DatabasePool(path: path)
        self.dbPool = dbPool

        try migrator.migrate(dbPool)
        return dbPool
    }

    static var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("create initial db") { (db) in
            try db.create(table: "users") { t in
                t.column("id", .text).primaryKey(onConflict: Database.ConflictResolution.replace, autoincrement: false)
                t.column("name", .text).notNull()
                t.column("username", .text).notNull().indexed()
                t.column("address", .text).notNull().indexed()
                t.column("imageFileKey", .text)
                t.column("pictureUrl", .text)
                t.column("isContact", .boolean).defaults(to: true)
                t.column("isBlocked", .boolean).defaults(to: false)
                t.column("lastMessage", .datetime)
                t.column("smallPhotoUrl", .text)
                t.column("mediumPhotoUrl", .text)
                t.column("originalPhotoUrl", .text)
            }

            try db.create(table: "wallets") { t in
                t.column("address", .text)
                t.column("filepath", .text)
                t.column("created", .datetime)
                t.column("balance", .text)
                t.column("currency", .text)
                t.column("isPrimary", .boolean)
                t.column("blockNumber", .text)
                t.column("startBlockNumber", .text)
                t.column("lastSynced", .datetime)
                t.primaryKey(["address", "currency"])
            }

            try db.create(table: "transactions") { t in
                t.column("hash", .text).primaryKey(onConflict: .replace, autoincrement: false)
                t.column("blockHash", .text).unique(onConflict: .replace).notNull()
                t.column("from", .text).notNull().indexed()
                t.column("to", .text).notNull().indexed()
                t.column("currency", .text).notNull().indexed()
                t.column("value", .text).notNull()
                t.column("timestamp", .datetime)
                t.column("gas", .text)
                t.column("confirmations", .text)
                t.column("nonce", .integer)
                t.column("message", .text)
                t.column("txReceipttatus", .text)
                t.column("fromUser_id", .text)
                t.column("fromUser_username", .text)
                t.column("fromUser_fullname", .text)
                t.column("fromuser_photoUrl", .text)
            }
        }

        return migrator
    }
}


