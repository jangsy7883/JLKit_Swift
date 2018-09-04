//
//  UINavigationBar+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 7. 3..
//  Copyright © 2018년 JLKit_Swift. All rights reserved.
//

import UIKit

extension UINavigationBar {
    var titleTintColor: UIColor? {
        set {
            var attributes: [NSAttributedStringKey: Any]?

            if titleTextAttributes != nil {
                attributes = titleTextAttributes
            } else {
                let navigationBar = UINavigationBar.appearance()
                if navigationBar.titleTextAttributes != nil {
                    attributes = navigationBar.titleTextAttributes
                } else {
                    attributes = [NSAttributedStringKey: Any]()
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
