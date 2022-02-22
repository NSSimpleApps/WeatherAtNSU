//
//  SceneDelegate.swift
//  WeatherAtNSU
//
//  Created by user on 15.06.2021.
//

import UIKit
import SwiftUI

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        UITabBar.appearance().backgroundColor = .white

        let nsuLabel = Constants.nsuLabel
        let inpLabel = Constants.inpLabel

        let weatherAtNSUContentView = WeatherContentView(weatherLoader: WeatherLoader.nsu, location: nsuLabel, image: Constants.nsuImageName)
        let weatherAtINPContentView = WeatherContentView(weatherLoader: WeatherLoader.inp, location: inpLabel, image: Constants.inpImageName)

        let tabView = TabView {
            weatherAtNSUContentView
                .tabItem {
                    Text(nsuLabel)
                }.tag(0)
            weatherAtINPContentView
                .tabItem {
                    Text(inpLabel)
                }.tag(1)
        }
            .frame(idealHeight: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = UIHostingController(rootView: tabView)
        self.window = window
        window.makeKeyAndVisible()
    }
}

