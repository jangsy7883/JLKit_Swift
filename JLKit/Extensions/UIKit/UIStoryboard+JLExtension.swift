//
//  UIStoryboard+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 2. 19..
//  Copyright © 2018년 Goodoc. All rights reserved.
//

extension UIStoryboard {
    public convenience init(name: String) {
        self.init(name: name, bundle: nil)
    }

    public static func viewController(_ identifier: String? = nil, storyboardName: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName)

        if identifier == nil {
            return storyboard.instantiateInitialViewController()
        } else if identifier?.isEmpty == false {
            return storyboard.instantiateViewController(withIdentifier: identifier!)
        }
        return nil
    }
}
