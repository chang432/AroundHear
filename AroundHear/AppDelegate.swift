//
//  AppDelegate.swift
//  AroundHear
//
//  Created by Guillermo on 3/19/19.
//  Copyright © 2019 Guillermo. All rights reserved.
//

import UIKit
import Firebase
import Firestore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate {
    
    
    var window: UIWindow?

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("success", session)
    }
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("fail", error)
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("renewed", session)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        return true
    }
    
    let SpotifyClientID = "c64fd829b4a84a44a9cf92ca16291374"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://around-hear.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://around-hear.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
            print("hi")
            print(tokenRefreshURL)
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        //Spotify Authorization
        let requestedScopes: SPTScope = [.appRemoteControl]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)

        if Auth.auth().currentUser != nil {
            
            let main = UIStoryboard(name: "Main", bundle: nil)
            let feedNavegationController = main.instantiateViewController(withIdentifier: "HomeTabBarController")
            window?.rootViewController = feedNavegationController
            
        }
//        let db = Firestore.firestore()
//
//        db.collection("cities").document("LA").setData([
//            "name": "Los Angeles",
//            "state": "CA",
//            "country": "USA"
//        ]) { (error: Error?) in
//            if let error = error{
//                print("\(error.localizedDescription)")
//            }else{
//                print("Success")
//            }
//        }
//
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

