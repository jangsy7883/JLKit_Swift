//
//  UITableViewCell+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UITableViewCell {
    @objc public var superTableView:UITableView? {
        var view = superview        
        while view != nil {
            if let tableView = view as? UITableView {
                return tableView
            }else {
                view = view?.superview
            }
        }
        return nil
    }
    
    @objc public var indexPath:IndexPath? {
        guard let tableView = superTableView else { return nil }
        return tableView.indexPath(for: self)
    }
}
