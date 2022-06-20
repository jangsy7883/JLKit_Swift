//
//  UICollectionViewDiffableDataSourceExtension.swift
//  TheDayBefore
//
//  Created by 장석용 on 2022/04/05.
//  Copyright © 2022 TheDayBefore. All rights reserved.
//

#if os(iOS)
import UIKit

public extension UICollectionViewDiffableDataSource {
    func reloadData(snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, completion: (() -> Void)? = nil) {
        if #available(iOS 15.0, *) {
            self.applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }

    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animated: Bool, completion: (() -> Void)? = nil) {
            if #available(iOS 15.0, *) {
                self.apply(snapshot, animatingDifferences: animated, completion: completion)
            } else {
                if animated {
                    self.apply(snapshot, animatingDifferences: true, completion: completion)
                } else {
                    UIView.performWithoutAnimation {
                        self.apply(snapshot, animatingDifferences: true, completion: completion)
                    }
                }
            }
        }
}

public extension UITableViewDiffableDataSource {
    func reloadData(snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, completion: (() -> Void)? = nil ) {
        if #available(iOS 15.0, *) {
            self.applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }

    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animated: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 15.0, *) {
            self.apply(snapshot, animatingDifferences: animated, completion: completion)
        } else {
            if animated {
                self.apply(snapshot, animatingDifferences: true, completion: completion)
            } else {
                // UIView.performWithoutAnimation {
                self.apply(snapshot, animatingDifferences: false, completion: completion)
                //                }
            }
        }
    }
}
#endif
