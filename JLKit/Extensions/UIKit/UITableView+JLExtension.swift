//
//  UITableView+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UITableView {
    
    public func indexPath(forCellContainingView:UIView?) -> IndexPath? {
        var view = forCellContainingView
        while view != nil {
            if let cell = view as? UITableViewCell {
                return indexPath(for: cell)
            } else if let superview = view?.superview {
                view = superview
            }
        }
        return nil
    }
}

