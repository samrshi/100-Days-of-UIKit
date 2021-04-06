//
//  SceneDelegate.swift
//  Milestone 10-12
//
//  Created by Samuel Shi on 4/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    
    let viewController = ViewController()
    let navigationVC = UINavigationController(rootViewController: viewController)
    
    window?.rootViewController = navigationVC
    window?.makeKeyAndVisible()
  }
}

