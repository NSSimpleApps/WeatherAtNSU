//
//  AppDelegate.swift
//  WeatherAtNSU
//
//  Created by user on 15.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
        } else {
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = WeatherViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

