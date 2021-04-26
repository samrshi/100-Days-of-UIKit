//
//  SceneDelegate.swift
//  MIlestone 13-15
//
//  Created by Samuel Shi on 4/24/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    window?.backgroundColor = .systemBackground
    
    let vc = CountryListVC()
    let navigationVC = UINavigationController(rootViewController: vc)
    window?.rootViewController = navigationVC
    window?.makeKeyAndVisible()
  }
}
