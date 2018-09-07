//
//  UIActivityViewController+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UIActivityViewController {
    
    @objc public convenience init(activityItems:[Any]) {
        self.init(activityItems: activityItems, applicationActivities: nil)
    }
    
    @objc public func show(animated:Bool = true) {
        UIViewController.topMostViewController()?.present(self, animated: animated, completion: nil)
    }
}
