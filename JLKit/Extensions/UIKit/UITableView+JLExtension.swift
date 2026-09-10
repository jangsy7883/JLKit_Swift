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
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
            indexPath.row >= 0 &&
            indexPath.section < numberOfSections &&
            indexPath.row < numberOfRows(inSection: indexPath.section)
    }

    func indexPath(forCellContainingView: UIView?) -> IndexPath? {
        var view = forCellContainingView
        while view != nil {
            if let cell = view as? UITableViewCell {
                return indexPath(for: cell)
            }
            view = view?.superview
        }
        return nil
    }

    func isLastRowOfSection(in indexPath: IndexPath) -> Bool {
        return numberOfRows(inSection: indexPath.section) - 1 == indexPath.row
    }

    func isLastSection(for indexPath: IndexPath) -> Bool {
        return numberOfSections - 1 == indexPath.section
    }
}
#endif
