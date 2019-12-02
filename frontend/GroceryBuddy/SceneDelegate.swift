//
//  SceneDelegate.swift
//  GroceryBuddy
//
//  Created by Shoji Moto on 10/31/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    let navigationController = UINavigationController()
    
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    
    let launchViewController = LaunchViewController()
    navigationController.pushViewController(launchViewController, animated: false)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}

