//
//  UIApplication+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UIApplication {
    @objc public static var isActive: Bool {
        return UIApplication.shared.applicationState == .active
    }
    
    @objc public static func open(_ url: URL, completionHandler completion: ((Bool) -> Swift.Void)? = nil) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, completionHandler: completion)
        }else {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
                completion?(true)
            }else {
                completion?(false)
            }
        }
    }
}
