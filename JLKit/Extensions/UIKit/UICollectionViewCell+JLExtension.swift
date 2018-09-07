//
//  UICollectionViewCell+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension UICollectionViewCell {
    @objc public var superCollectionView:UICollectionView? {
        var view = superview
        
        while view != nil {
            if let tableView = view as? UICollectionView {
                return tableView
            }else {
                view = view?.superview
            }
        }
        return nil
    }
    
    @objc public var indexPath:IndexPath? {
        guard let collectionView = superCollectionView else { return nil }
        return collectionView.indexPath(for: self)
    }
}
