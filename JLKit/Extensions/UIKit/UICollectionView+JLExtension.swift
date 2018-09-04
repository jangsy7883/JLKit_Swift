//
//  UICollectionView+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        if indexPath.section >= numberOfSections {
            return false
        } else if indexPath.row >= numberOfItems(inSection: indexPath.section) {
            return false
        }
        
        return true
    }
    
    func indexPath(forCellContainingView:UIView?) -> IndexPath? {
        var view = forCellContainingView
        while view != nil {
            if let cell = view as? UICollectionViewCell {
                return indexPath(for: cell)
            } else if let superview = view?.superview {
                view = superview
            }
        }
        
        return nil
    }
    
    func performBatchUpdates(_ updates: (() -> Swift.Void)?, animated:Bool, completion: ((Bool) -> Swift.Void)? = nil) {
        let animationsEnabled = UIView.areAnimationsEnabled
        
        UIView.setAnimationsEnabled(animated)
        performBatchUpdates(updates) { (isFinished) in
            UIView.setAnimationsEnabled(animationsEnabled)
            completion?(isFinished)
        }
    }
}
