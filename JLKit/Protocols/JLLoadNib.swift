//
//  JLLoadNib.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 14..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if os(iOS)
import UIKit

public protocol JLLoadNib { }

extension UIView: JLLoadNib {}

extension JLLoadNib where Self: UIView {
    public static func loadNib(_ name: String? = nil, bundle: Bundle = Bundle.main) -> Self? {
        guard let views = bundle.loadNibNamed(name ?? String(describing: self.self), owner: self, options: nil) else { return nil }
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
    public static func loadNib(bundle: Bundle? = nil) -> Self? {
        return Self(nibName: String(describing: self.self), bundle: bundle)
    }
}
#endif
