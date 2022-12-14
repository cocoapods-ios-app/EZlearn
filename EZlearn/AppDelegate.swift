//
//  AppDelegate.swift
//  EZlearn
//
//  Created by Sharonda Daniels
//

import UIKit
import CoreData
import FirebaseCore
import Firebase
import GoogleSignIn

/*
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "EZlearnCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {

                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
    
        // Override point for customization after application launch.
        //Firebase.app
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}*/


import GoogleSignIn
import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "EZlearnCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {

                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    /*
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // --- Copy this only
        
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "RpK4BMepTRL7H0EdKR0rwXzT1oMakThQRwCDI1A2" // <- UPDATE
                $0.clientKey = "biZg2JTyeqWpnreB2cMaRn8jIPyAcgNIZWhb9u20" // <- UPDATE
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
        
        // --- end copy


        return true
    }
*/
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Initialize Google sign-in.
        GIDSignIn.sharedInstance().clientID = "137751831802-imk5cbs9nfror60a33t7ot8nicl6cdgd.apps.googleusercontent.com"
        
        
        
        let parseConfig = ParseClientConfiguration {
                $0.applicationId = "RpK4BMepTRL7H0EdKR0rwXzT1oMakThQRwCDI1A2" // <- UPDATE
                $0.clientKey = "biZg2JTyeqWpnreB2cMaRn8jIPyAcgNIZWhb9u20" // <- UPDATE
                $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: parseConfig)
    }

    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }

}

