//
//  AppDelegate.swift
//  Basic Integration
//
//  Created by Jack Flintermann on 1/15/15.
//  Copyright (c) 2015 Stripe. All rights reserved.
//

import UIKit
import Stripe
import Firebase
import FirebaseFunctions


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Creating root view controller to be the Browse VC
//        let rootVC = BrowseProductsViewController()
//        let navigationController = UINavigationController(rootViewController: rootVC)
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.rootViewController = navigationController;
//        window.makeKeyAndVisible()
//        self.window = window
        FirebaseApp.configure()
        
        var functions = Functions.functions(region: "us-central1")
        
        functions.httpsCallable("getStripePublishablekey").call { (response, error) in
            if let error = error {
                print(error)
            }
            if let response = (response?.data as? [String: Any]) {
                let stripePublishableKey = response["publishableKey"] as! String?
                Stripe.setDefaultPublishableKey(stripePublishableKey!)
                print(stripePublishableKey)
            }
        }
        
        
        
        return true
    }

    // This method is where you handle URL opens if you are using a native scheme URLs (eg "yourexampleapp://")
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let stripeHandled = Stripe.handleURLCallback(with: url)

        if (stripeHandled) {
            return true
        } else {
            // This was not a stripe url, do whatever url handling your app
            // normally does, if any.
        }

        return false
    }

    // This method is where you handle URL opens if you are using univeral link URLs (eg "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = Stripe.handleURLCallback(with: url)

                if (stripeHandled) {
                    return true
                } else {
                    // This was not a stripe url, do whatever url handling your app
                    // normally does, if any.
                }
            }
            
        }
        return false
    }
}
