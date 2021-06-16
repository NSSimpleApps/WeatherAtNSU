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
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        window.rootViewController = UIHostingController(rootView: WeatherContentView())
        self.window = window
        window.makeKeyAndVisible()
    }
}

