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
            let nsuLabel = Constants.nsuLabel
            let inpLabel = Constants.inpLabel
            
            let weatherAtNSUViewController = WeatherViewController(weatherLoader: .init(url: WeatherLoader.nsuURL,
                                                                                        pattern: WeatherLoader.nsuPattern),
                                                                   location: nsuLabel, image: Constants.nsuImageName)
            weatherAtNSUViewController.tabBarItem = UITabBarItem(title: nsuLabel, image: nil, tag: 0)
            let weatherAtINPViewController = WeatherViewController(weatherLoader: .init(url: WeatherLoader.inpURL,
                                                                                        pattern: WeatherLoader.inpPattern),
                                                                   location: inpLabel, image: Constants.inpImageName)
            weatherAtINPViewController.tabBarItem = UITabBarItem(title: inpLabel, image: nil, tag: 1)
            
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [weatherAtNSUViewController, weatherAtINPViewController]
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = tabBarController
            self.window = window
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

