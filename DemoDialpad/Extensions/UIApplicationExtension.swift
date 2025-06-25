//
//  UIApplicationExtension.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//

import UIKit

//MARK: - UIApplication
extension UIApplication {
    var appDeleagte: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var sceneDelegate: SceneDelegate? {
        return windowScenes
            .first?
            .delegate as? SceneDelegate
    }
    
    var windowScenes: [UIWindowScene] {
        let scenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
        
        let activeScenes = scenes.filter({ $0.activationState == .foregroundActive })
        if !activeScenes.isEmpty {
            return activeScenes
        }
        
        return scenes
    }
    
    var firstWindowScene: UIWindowScene? {
        return windowScenes.first
    }
    
    var activeKeyWindow: UIWindow? {
        if #available(iOS 15.0, *) {
            return windowScenes
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
    }
    
    func getTopViewController(
        base: UIViewController? = UIApplication.shared.activeKeyWindow?.rootViewController
    ) -> UIViewController? {
        // If the base is a navigation controller, get its visible (top) view controller.
        if let navigationController = base as? UINavigationController {
            return getTopViewController(base: navigationController.visibleViewController)
        }
        
        // If the base is a tab bar controller, get the currently selected view controller.
        if let tabBarController = base as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return getTopViewController(base: selectedViewController)
        }
        
        // If the base is presenting another view controller, follow the presentation chain.
        if let presentedViewController = base?.presentedViewController {
            return getTopViewController(base: presentedViewController)
        }
        
        // Return the top-most view controller.
        return base
    }
}
