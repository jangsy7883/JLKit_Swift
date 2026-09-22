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
    /// 앱 window 기준 최상단 뷰컨트롤러 — "지금 사용자가 보고 있는 화면 위에 띄운다"의 기준점.
    /// `UIWindow.app`이 없는 앱(씬 델리게이트 window 미소유)은 key window로 폴백한다.
    public class var appTopMost: UIViewController? {
        topMost((UIWindow.app ?? UIWindow.keyFallback)?.rootViewController)
    }

    @available(*, deprecated, renamed: "appTopMost")
    public class func topMost() -> UIViewController? {
        return appTopMost
    }

    /// 주어진 뷰컨트롤러에서 presented → 탭 → 내비 → 스플릿 → 페이지 순으로 내려간 최상단.
    /// 라벨을 `of:`로 두지 않는 건 의도적이다 — URLNavigator가 같은 시그니처의 `topMost(of:)`를 정의하므로
    /// 두 모듈을 함께 import 하는 파일에서 모호성 에러가 난다.
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
