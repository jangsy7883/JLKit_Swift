//
//  UISearchBar+JLExtension.swift
//  JLKit_Swift
//
//  Created by Woody on 12/10/2018.
//  Copyright © 2018 Woody. All rights reserved.
//

import UIKit

extension UISearchBar {

    @objc public var textField:UITextField? {
        
        func findTextField(in view:UIView?) -> UITextField? {
            if let textField = view as? UITextField {
                return textField
            
            } else if let views = view?.subviews {
                for view in views {
                    if let textField = findTextField(in: view) {
                        return textField
                    }
                }
            }
            return nil
        }
        return findTextField(in: self)
    }
}
