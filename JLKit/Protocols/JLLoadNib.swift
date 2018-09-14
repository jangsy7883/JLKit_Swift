//
//  JLLoadNib.swift
//  JLKit_Swift
//
//  Created by Woody on 2018. 9. 14..
//  Copyright © 2018년 Woody. All rights reserved.
//

import UIKit

public protocol JLLoadNib { }

extension UIView: JLLoadNib {}

extension JLLoadNib where Self: UIView {
    public static func loadNib(_ name: String? = nil) -> Self? {
        guard let views = Bundle.main.loadNibNamed(name ?? String(describing: self.self), owner: self, options: nil) else { return nil }
        for view in views {
            
            if let view = view as? Self {
                return view
            }
        }
        return nil
    }
}


extension UIViewController: JLLoadNib {}

extension JLLoadNib where Self: UIViewController {
    public static func loadNib() -> Self? {
        return Self(nibName: String(describing: self.self), bundle: nil)
    }
}

