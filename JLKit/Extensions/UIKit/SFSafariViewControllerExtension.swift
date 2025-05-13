//
//  SFSafariViewControllerExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2022/04/01.
//  Copyright © 2022 Woody. All rights reserved.
//
#if canImport(SafariServices)
import SafariServices

public extension SFSafariViewController {
    func show(in viewController: UIViewController? = UIViewController.topMost(), animated: Bool = true) {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.isNavigationBarHidden = true
        viewController?.present(navigationController, animated: animated, completion: nil)
    }
    
    @MainActor func show(in viewController: UIViewController? = nil, animated: Bool = true) async {
        guard let controller = viewController ?? UIViewController.topMost() else { return }
        await withCheckedContinuation { continuation in
            let navigationController = UINavigationController(rootViewController: self)
            navigationController.isNavigationBarHidden = true
            controller.present(navigationController, animated: animated) {
                continuation.resume()
            }
        }
    }
}
#endif
