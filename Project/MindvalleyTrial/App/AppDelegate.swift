//
//  AppDelegate.swift
//  MindvalleyTrial
//
//  Created by Yauheni Klishevich on 23.06.2020.
//  Copyright © 2020 Yauheni Klishevich. All rights reserved.
//

import UIKit
import XCGLogger

let log = XCGLogger.default

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var rootRouter: RootRouter!
    var window: UIWindow? {
        didSet {
            rootRouter.setupRouter(window: window!)
        }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpLoggingFramework()
        rootRouter = RootRouter()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

// - MARK: Helpers
private extension AppDelegate {
    
    private func setUpLoggingFramework() {
        var consoleLogLevel: XCGLogger.Level = .info
        #if DEBUG
            consoleLogLevel = .verbose
        #endif
        
        log.setup(level: consoleLogLevel,
                  showThreadName: true,
                  showLevel: true,
                  showFileNames: true,
                  showLineNumbers: true,
                  writeToFile: nil,
                  fileLevel: nil)
        
        log.logAppDetails()
        log.debug(
            "Location of documents dir: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!)"
        )
    }
    
}

