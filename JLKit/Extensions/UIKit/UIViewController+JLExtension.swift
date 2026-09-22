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
    /// `topMost()` 탐색의 출발점.
    ///
    /// 씬 델리게이트가 소유한 앱 기본 window를 우선한다. key window는 스낵바·광고처럼 코드로 띄운
    /// 오버레이 window가 터치 한 번으로 가져갈 수 있어서, 그 기준으로 present 하면 오버레이가
    /// 내려갈 때 띄운 화면도 함께 사라진다. 델리게이트 window는 앱이 직접 만든 것 하나뿐이므로
    /// 오버레이가 구조적으로 배제된다. (씬 델리게이트가 window를 안 갖는 앱은 기존 key window 폴백)
    private class var keyRootViewController: UIViewController? {
        let selector = NSSelectorFromString("sharedApplication")
        guard let application = UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication else { return nil }

        let scenes = application.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first

        if let appWindow = (scene?.delegate as? UIWindowSceneDelegate)?.window ?? nil {
            return appWindow.rootViewController
        }

        return scenes
            .flatMap { $0.windows }
            .last { $0.isKeyWindow }?
            .rootViewController
    }

    public class func topMost() -> UIViewController? {
        return topMost(keyRootViewController)
    }

    public class func topMost(_ viewController: UIViewController?) -> UIViewController? {
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

    public var isPresented: Bool {
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
