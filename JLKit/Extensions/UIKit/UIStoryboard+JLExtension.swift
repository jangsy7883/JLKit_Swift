//
//  UIStoryboard+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 19..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if os(iOS)
import UIKit

extension UIStoryboard {
    public struct Name {
        public let name: String
        
        public init(_ name: String) {
            self.name = name
        }
        
        public func viewController(identifier: String) -> UIViewController {
            let storyboard = UIStoryboard(name: self.name, bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: identifier)
        }

        public func initialViewController() -> UIViewController? {
            let storyboard = UIStoryboard(name: self.name, bundle: nil)
            return storyboard.instantiateInitialViewController()
        }
    }
    
    public static var main = UIStoryboard.Name("Main")
}

extension UIStoryboard {
    @objc public convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }

    @objc public static func viewController(_ identifier: String? = nil, storyboardName: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName)

        if identifier == nil {
            return storyboard.instantiateInitialViewController()
        } else if identifier?.isEmpty == false {
            return storyboard.instantiateViewController(withIdentifier: identifier!)
        }
        return nil
    }
}
#endif
