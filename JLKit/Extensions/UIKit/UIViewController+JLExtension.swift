//
//  UIViewController+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if os(iOS)
import UIKit

extension UIStoryboard {
    public struct Name {
        let name: String
        
        public init(_ name: String) {
            self.name = name
        }
        
        public func viewController(identifier: String) -> UIViewController {
            let storyboard = UIStoryboard(name: self.name, bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: identifier)
        }

        public func initialViewController() -> UIViewController? {
            let storyboard = UIStoryboard(name: self.name, bundle: nil)
            return storyboard.instantiateInitialViewController()
        }
    }
}

extension UIStoryboard.Name {
    static var main = UIStoryboard.Name("Main")
}

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
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
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

    public static func instantiate(storyboard: UIStoryboard.Name, identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard.name, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    public static func instantiate(storyboard: UIStoryboard.Name) -> Self {
        return instantiate(storyboard: storyboard, identifier: String(describing: self)) as! Self
    }
}

#endif
