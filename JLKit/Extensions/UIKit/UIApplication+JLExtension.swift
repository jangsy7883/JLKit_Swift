//
//  UIApplication+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UIApplication {
    static var isActive: Bool {
        return UIApplication.shared.applicationState == .active
    }
    
    func open(_ url: URL, completionHandler completion: ((Bool) -> Swift.Void)? = nil) {
        if #available(iOS 10, *) {
            open(url, options: [String : Any]() , completionHandler: completion)
        }else {
            if canOpenURL(url) {
                open(url)
                completion?(true)
            }else {
                completion?(false)
            }
        }
    }
}
