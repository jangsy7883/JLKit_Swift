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

        // parent 체인의 최상위 조상이 modal로 present된 객체인지 확인
        // (직접 present, nav root, 탭 root, 컨테이너에 embed된 경우 모두 커버)
        var top: UIViewController = self
        while let parent = top.parent {
            top = parent
        }
        return top.presentingViewController?.presentedViewController === top
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
