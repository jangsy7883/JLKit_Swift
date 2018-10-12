//
//  UIViewController+JLExtension.swift
//  JLKit_Swift
//
//  Created by Woody on 2018. 9. 4..
//  Copyright © 2018년 Woody. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc public static func topMostViewController(_ baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = baseViewController as? UINavigationController {
            return topMostViewController(navigationController.visibleViewController)
        }
        
        if let tabBarViewController = baseViewController as? UITabBarController {
            if let topViewController = tabBarViewController.moreNavigationController.topViewController, topViewController.view.window != nil {
                return topMostViewController(topViewController)
            } else if let selectedViewController = tabBarViewController.selectedViewController {
                return topMostViewController(selectedViewController)
            }
        }
        if let splitViewController = baseViewController as? UISplitViewController, splitViewController.viewControllers.count == 1 {
            return topMostViewController(splitViewController.viewControllers.first)
        }
        if let presentedViewController = baseViewController?.presentedViewController {
            return topMostViewController(presentedViewController)
        }
        
        return baseViewController
    }
    
    @objc public var isPresented: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
