//
//  SceneDelegate.swift
//  HRHN
//
//  Created by Chanhee Jeong on 2022/12/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        lazy var initialViewController = TabBarController()
        lazy var onBoarding = OnBoardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        if UserDefaults.hasOnBoarded {
            self.window?.rootViewController = initialViewController
        } else {
            self.window?.rootViewController = onBoarding
        }
        
        self.window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataManager.shared.saveContext()
    }
    
    
}

