//
//  UINavigationBar+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 7. 3..
//  Copyright © 2018년 JLKit_Swift. All rights reserved.
//

import UIKit

extension UINavigationBar {
    public var titleTintColor: UIColor? {
        set {
            var attributes: [NSAttributedString.Key: Any]?

            if titleTextAttributes != nil {
                attributes = titleTextAttributes
            } else {
                let navigationBar = UINavigationBar.appearance()
                if navigationBar.titleTextAttributes != nil {
                    attributes = navigationBar.titleTextAttributes
                } else {
                    attributes = [NSAttributedString.Key: Any]()
                }
            }

            attributes?[.foregroundColor] = newValue
            titleTextAttributes = attributes
        }
        get {
            if let color = titleTextAttributes?[.foregroundColor] as? UIColor {
                return color
            }
            return nil
        }
    }
}
