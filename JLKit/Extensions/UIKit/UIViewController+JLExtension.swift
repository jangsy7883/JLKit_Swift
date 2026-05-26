//
//  UIViewController+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

extension UIViewController {
    private class var keyRootViewController: UIViewController? {
        let selector = NSSelectorFromString("sharedApplication")
        guard let application = UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication else { return nil }

        let window = application.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .last { $0.isKeyWindow }

        return window?.rootViewController
        /*
        if let viewController = application.keyWindow?.rootViewController {
            return viewController
        }else {
            return application.windows.filter{ $0.rootViewController != nil }.first { $0.isKeyWindow }?.rootViewController
        }
         */
    }

    @objc open class func topMost() -> UIViewController? {
        return topMost(keyRootViewController)
    }

    @objc open class func topMost(_ viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return topMost(presentedViewController)
        }

        // UITabBarController
        if let tabBarViewController = viewController as? UITabBarController {
            if let topViewController = tabBarViewController.moreNavigationController.topViewController, topViewController.view.window != nil {
                return topMost(topViewController)
            } else if let selectedViewController = tabBarViewController.selectedViewController {
                return topMost(selectedViewController)
            }
        }

        // UINavigationController
        if let visibleViewController = (viewController as? UINavigationController)?.visibleViewController {
            return topMost(visibleViewController)
        }

        // UISplitViewController
        if let splitViewController = viewController as? UISplitViewController, splitViewController.viewControllers.count == 1 {
            return topMost(splitViewController.viewControllers.first)
        }

        // UIPageController
        if let pageViewController = viewController as? UIPageViewController, pageViewController.viewControllers?.count == 1 {
          return topMost(pageViewController.viewControllers?.first)
        }

        return viewController
    }

    @objc public var isPresented: Bool {
        // nav stack에서 push된 child VC
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        }

        // self(또는 self의 nav)가 tabBarController의 탭 root인 경우
        // → tabBarController 자체가 modal로 present 되었을 때만 true
        if let tabBar = tabBarController {
            let isTabRoot = (navigationController.map { tabBar.viewControllers?.contains($0) ?? false } ?? false)
                         || (tabBar.viewControllers?.contains(self) ?? false)
            if isTabRoot {
                return tabBar.presentingViewController != nil
            }
        }

        // self가 nav의 root이고, nav가 modal로 present 된 경우
        if let nav = navigationController,
           nav.viewControllers.first === self,
           nav.presentingViewController?.presentedViewController === nav {
            return true
        }

        // self가 직접 modal로 present 된 경우
        return presentingViewController != nil && navigationController == nil
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
