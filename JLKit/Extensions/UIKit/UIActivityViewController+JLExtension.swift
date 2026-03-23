//
//  UIActivityViewController+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UIActivityViewController {
    @objc convenience init(activityItems: [Any]) {
        self.init(activityItems: activityItems, applicationActivities: nil)
    }

    @objc func show(animated: Bool = true) {
        UIViewController.topMost()?.present(self, animated: animated, completion: nil)
    }
}
#endif
