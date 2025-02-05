//
//  SceneDelegate.swift
//  AppGestionUAM
//
//  Created by David Sanchez on 31/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
       
        
        // Crear la ventana principal
        let window = UIWindow(windowScene: windowScene)
        
        
        // Establecer CourseListViewController como el controlador raíz
        let courseListViewController = CourseListViewController()
        let navigationController = UINavigationController(rootViewController: courseListViewController)
        window.rootViewController = navigationController
        
        // Hacer visible la ventana
        self.window = window
        window.makeKeyAndVisible()
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
    }
}
