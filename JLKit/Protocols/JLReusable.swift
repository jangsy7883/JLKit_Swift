//
//  JLReusable.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 3. 12..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public protocol JLReusable {}

extension JLReusable where Self: UIViewController {
    internal static var reuseIdentifier: String {
        return String(describing: self.self)
    }
}

extension JLReusable where Self: UIView {
    internal static var reuseIdentifier: String {
        return String(describing: self.self)
    }
}

public protocol JLNibLoadable { }

extension JLNibLoadable where Self: UIViewController {
    internal static func loadNib() -> Self? {
        return Self(nibName: String(describing: self.self), bundle: nil)
    }
}

extension JLNibLoadable where Self: UIView {
    internal static var nib: UINib? {
        return UINib(nibName: String(describing: self.self), bundle: nil)
    }
    
    internal static func loadNib() -> Self? {
        guard let views = Bundle.main.loadNibNamed(String(describing: self.self), owner: self, options: nil) else { return nil }
        for view in views {
            if let view = view as? Self {
                return view
            }
        }
        return nil
    }
}

extension UITableView {
    internal func register<T: UITableViewCell & JLReusable>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func register<T: UITableViewCell & JLReusable & JLNibLoadable>(_: T.Type) {
        guard let nib = T.nib else { return }
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func register<T: UITableViewHeaderFooterView & JLReusable>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func register<T: UITableViewHeaderFooterView & JLReusable & JLNibLoadable>(_: T.Type) {
        guard let nib = T.nib else { return }
        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: JLReusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    internal func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: JLReusable {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            return nil
        }
        return view
    }
}

extension UICollectionView {
    internal func register<T: UICollectionReusableView & JLReusable>(_: T.Type, forSupplementaryViewOfKind elementKind: String) {
        register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func register<T: UICollectionReusableView & JLReusable & JLNibLoadable>(_: T.Type, forSupplementaryViewOfKind elementKind: String) {
        guard let nib = T.nib else { return }
        register(nib, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func register<T: UICollectionViewCell & JLReusable>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func register<T: UICollectionViewCell & JLReusable & JLNibLoadable>(_: T.Type) {
        guard let nib = T.nib else { return }
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    internal func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: JLReusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
    
    internal func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind elementKind: String, for indexPath: IndexPath) -> T where T: JLReusable {
        guard let view = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return view
    }
    
}
