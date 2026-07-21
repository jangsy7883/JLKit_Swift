#if canImport(UIKit)
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
        applySnapshotUsingReloadData(snapshot, completion: completion)
    }

    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animated: Bool, completion: (() -> Void)? = nil) {
        apply(snapshot, animatingDifferences: animated, completion: completion)
    }
}

public extension UITableViewDiffableDataSource {
    func reloadData(snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, completion: (() -> Void)? = nil) {
        applySnapshotUsingReloadData(snapshot, completion: completion)
    }

    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>, animated: Bool, completion: (() -> Void)? = nil) {
        apply(snapshot, animatingDifferences: animated, completion: completion)
    }
}
#endif
#endif
