//
//  JLReusable.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 3. 12..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit)
import Foundation
import UIKit

public protocol JLReusable {}

public extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self.self)
    }
}

public extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String {
        return String(describing: self.self)
    }
}

public extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: self.self)
    }
}

public protocol JLNibLoadable {}

public extension JLNibLoadable where Self: UIView {
    static func nib(bundle: Bundle? = nil) -> UINib? {
        return UINib(nibName: String(describing: self.self), bundle: bundle)
    }
}

public extension UITableView {
    func register<T: UITableViewCell>(_: T.Type, bundle: Bundle? = nil) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewCell & JLNibLoadable>(_: T.Type, bundle: Bundle? = nil) {
        guard let nib = T.nib(bundle: bundle) else { return }

        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UITableViewHeaderFooterView & JLNibLoadable>(_: T.Type, bundle: Bundle? = nil) {
        guard let nib = T.nib(bundle: bundle) else { return }

        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            return nil
        }

        return view
    }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type, bundle: Bundle? = nil) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionViewCell & JLNibLoadable>(_: T.Type, bundle: Bundle? = nil) {
        guard let nib = T.nib(bundle: bundle) else { return }

        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind elementKind: String = T.reuseIdentifier, bundle: Bundle? = nil) {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView & JLNibLoadable>(_: T.Type, forSupplementaryViewOfKind elementKind: String = T.reuseIdentifier, bundle: Bundle? = nil) {
        guard let nib = T.nib(bundle: bundle) else { return }

        register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }

        return view
    }
    }
#endif
