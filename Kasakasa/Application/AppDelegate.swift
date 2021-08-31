//
//  AppDelegate.swift
//  Kasakasa
//
//  Created by John Warmann on 2019-01-03.
//  Copyright © 2019 Tip Blockchain. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appDefaults = AppDefaults.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        AppStyle.initialize()
        AppConfig.initalize()
        appDefaults.initialize()

        try! self.setupDatabase(application)
        if let wallets = WalletRepository.shared.allWallets() {
            debugPrint("Wallet count = \(wallets.count)")
        }
        if let ipAddress = self.getIpAddress() {
            debugPrint("***** IP ADDRESS = \(ipAddress)")
        }

        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        appDefaults.save()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        appDefaults.save()
    }


    private func setupDatabase(_ application: UIApplication) throws {
        try FileUtils.createDatabaseDirectoryIfNotExists()
        let dbUrl = FileUtils.databaseDirectoryUrl()?.appendingPathComponent("db.sqlite")
        let dbPool = try AppDatabase.openDatabase(atPath: dbUrl!.path)
        dbPool.setupMemoryManagement(in: application)
    }

    private func getIpAddress() -> String? {
        var address : String?

         // Get list of all interfaces on the local machine:
         var ifaddr : UnsafeMutablePointer<ifaddrs>?
         guard getifaddrs(&ifaddr) == 0 else { return nil }
         guard let firstAddr = ifaddr else { return nil }

         // For each interface ...
         for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
             let interface = ifptr.pointee

             // Check for IPv4 or IPv6 interface:
             let addrFamily = interface.ifa_addr.pointee.sa_family
             if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                 // Check interface name:
                 let name = String(cString: interface.ifa_name)
                 if  name == "en0" {

                     // Convert interface address to a human readable string:
                     var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                     getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                 &hostname, socklen_t(hostname.count),
                                 nil, socklen_t(0), NI_NUMERICHOST)
                     address = String(cString: hostname)
                 }
             }
         }
         freeifaddrs(ifaddr)

         return address
    }
}

