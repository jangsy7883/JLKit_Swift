//
//  UIAlertController+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 8. 24..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UIAlertController {

    @discardableResult public convenience init(aTitle: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]? = nil) {
        if preferredStyle == .alert || aTitle == nil {
            self.init(title: "", message: message, preferredStyle: preferredStyle)
        } else {
            self.init(title: aTitle, message: message, preferredStyle: preferredStyle)
        }

        actions?.forEach { (action) in
         self.addAction(action)
        }
    }

    @discardableResult public func addAction(_ title: String?, style: UIAlertAction.Style = .default, handler: ((UIAlertAction) -> Swift.Void)? = nil) -> Self {
        addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }

    public func setSourceView(_ view: UIView, permittedArrowDirections directions: UIPopoverArrowDirection = .any) -> Self {
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
        popoverPresentationController?.permittedArrowDirections = directions        
        return self
    }

    public func show(animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        UIViewController.topMostViewController()?.present(self, animated: animated, completion: completion)
    }
}
