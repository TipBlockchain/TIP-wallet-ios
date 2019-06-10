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

            try db.create(table: User.databaseTableName) { t in

                t.column(User.Columns.id.rawValue, .text).primaryKey(onConflict: Database.ConflictResolution.replace, autoincrement: false)
                t.column(User.Columns.fullname.rawValue, .text).notNull()
                t.column(User.Columns.username.rawValue, .text).notNull().indexed()
                t.column(User.Columns.address.rawValue, .text).notNull().indexed()
                t.column(User.Columns.imageFileKey.rawValue, .text)
                t.column(User.Columns.pictureUrl.rawValue, .text)
                t.column(User.Columns.created.rawValue, .date)
                t.column(User.Columns.isContact.rawValue, .boolean).defaults(to: true)
                t.column(User.Columns.isBlocked.rawValue, .boolean).defaults(to: false)
                t.column(User.Columns.lastMessage.rawValue, .datetime)
                t.column(User.Columns.aboutMe.rawValue, .text)
                t.column(User.Columns.smallPhotoUrl.rawValue, .text)
                t.column(User.Columns.mediumPhotoUrl.rawValue, .text)
                t.column(User.Columns.originalPhotoUrl.rawValue, .text)
            }

            try db.create(table: Wallet.databaseTableName) { t in

                t.column(Wallet.Columns.address.rawValue, .text)
                t.column(Wallet.Columns.filePath.rawValue, .text)
                t.column(Wallet.Columns.created.rawValue, .datetime)
                t.column(Wallet.Columns.balance.rawValue, .text)
                t.column(Wallet.Columns.currency.rawValue, .text)
                t.column(Wallet.Columns.isPrimary.rawValue, .boolean)
                t.column(Wallet.Columns.blockNumber.rawValue, .text)
                t.column(Wallet.Columns.startBlockNumber.rawValue, .text)
                t.column(Wallet.Columns.lastSynced.rawValue, .datetime)

                t.primaryKey([Wallet.Columns.address.rawValue, Wallet.Columns.currency.rawValue])
            }

            try db.create(table: Transaction.databaseTableName) { t in
                
                t.column(Transaction.Columns.hash.rawValue, .text).primaryKey(onConflict: .replace, autoincrement: false)
                t.column(Transaction.Columns.blockHash.rawValue, .text).notNull()
                t.column(Transaction.Columns.from.rawValue, .text).notNull().indexed()
                t.column(Transaction.Columns.to.rawValue, .text).notNull().indexed()
                t.column(Transaction.Columns.currency.rawValue, .text).notNull().indexed()
                t.column(Transaction.Columns.value.rawValue, .text).notNull()
                t.column(Transaction.Columns.timestamp.rawValue, .datetime)
                t.column(Transaction.Columns.gas.rawValue, .text)
                t.column(Transaction.Columns.confirmations.rawValue, .text)
                t.column(Transaction.Columns.nonce.rawValue, .integer)
                t.column(Transaction.Columns.message.rawValue, .text)
                t.column(Transaction.Columns.txReceiptStatus.rawValue, .text)

                t.column(Transaction.Columns.fromUserId.rawValue, .text)
                t.column(Transaction.Columns.fromUsername.rawValue, .text)
                t.column(Transaction.Columns.fromFullname.rawValue, .text)
                t.column(Transaction.Columns.fromPhotoUrl.rawValue, .text)

                t.column(Transaction.Columns.toUserId.rawValue, .text)
                t.column(Transaction.Columns.toUsername.rawValue, .text)
                t.column(Transaction.Columns.toFullname.rawValue, .text)
                t.column(Transaction.Columns.toPhotoUrl.rawValue, .text)
            }
        }

        return migrator
    }
}
