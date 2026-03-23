//
//  UITableView+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension UITableView {
    @objc func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        if indexPath.section >= numberOfSections {
            return false
        } else if indexPath.row >= numberOfRows(inSection: indexPath.section) {
            return false
        }
        return true
    }

    @objc func indexPath(forCellContainingView: UIView?) -> IndexPath? {
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

    @objc func isLastRowOfSection(in indexPath: IndexPath) -> Bool {
        return numberOfRows(inSection: indexPath.section) - 1 == indexPath.row
    }

    @objc func isLastSection(for indexPath: IndexPath) -> Bool {
        return numberOfSections - 1 == indexPath.section
    }
}
#endif
