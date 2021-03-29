//
//  UIApplication+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIApplication {
    private class var sharedApplication: UIApplication? {
      let selector = NSSelectorFromString("sharedApplication")
      return UIApplication.perform(selector)?.takeUnretainedValue() as? UIApplication
    }
    
    @objc public static var isActive: Bool {
        return UIApplication.sharedApplication?.applicationState == .active
    }
    
    @objc public static func open(_ url: URL, completionHandler completion: ((Bool) -> Swift.Void)? = nil) {
        guard let application = UIApplication.sharedApplication else {
            completion?(false)
            return
        }
        
        if #available(iOS 10, *) {
            application.open(url, completionHandler: completion)
        }else {
            if application.canOpenURL(url) {
                application.openURL(url)
                completion?(true)
            }else {
                completion?(false)
            }
        }
    }
}
#endif
