//
//  UICollectionView+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if os(iOS)
import UIKit

public extension UICollectionView {
    var indexPathForLastItem: IndexPath? {
        return indexPathForLastItem(inSection: lastSection)
    }
    
    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
}

public extension UICollectionView {
    
    func isValidIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section >= 0 &&
        indexPath.item >= 0 &&
        indexPath.section < numberOfSections &&
        indexPath.item < numberOfItems(inSection: indexPath.section)
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
    
    func indexPathForLastItem(inSection section: Int) -> IndexPath? {
        guard section >= 0 else {
            return nil
        }
        guard section < numberOfSections else {
            return nil
        }
        guard numberOfItems(inSection: section) > 0 else {
            return IndexPath(item: 0, section: section)
        }
        return IndexPath(item: numberOfItems(inSection: section) - 1, section: section)
    }
    
    func safeScrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        guard indexPath.item >= 0,
              indexPath.section >= 0,
              indexPath.section < numberOfSections,
              indexPath.item < numberOfItems(inSection: indexPath.section) else {
                  return
              }
        scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
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

#endif
