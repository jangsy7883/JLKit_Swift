//
//  JLNibLoadable.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 14..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

public protocol JLNibLoadable {}

public extension JLNibLoadable where Self: UIView {
    static func nib(bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: String(describing: self), bundle: bundle)
    }

    static func loadNib(_ name: String? = nil, bundle: Bundle = Bundle.main) -> Self? {
        guard let views = bundle.loadNibNamed(name ?? String(describing: self), owner: self, options: nil) else { return nil }

        for view in views {
            if let view = view as? Self {
                return view
            }
        }
        return nil
    }
}

public extension JLNibLoadable where Self: UIViewController {
    static func loadNib(bundle: Bundle? = nil) -> Self {
        return Self(nibName: String(describing: self), bundle: bundle)
    }
}
#endif
