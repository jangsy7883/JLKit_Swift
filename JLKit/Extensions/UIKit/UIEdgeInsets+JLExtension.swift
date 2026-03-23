#if canImport(UIKit)
//
//  UIEdgeInsets+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 19/06/2019.
//  Copyright © 2019 Woody. All rights reserved.
//
#if os(iOS)
import UIKit

public extension UIEdgeInsets {
    enum Position {
        case top
        case bottom
        case left
        case right
    }

    func insetsBySet(_ set: [Position: CGFloat]) -> UIEdgeInsets {
        var inset: UIEdgeInsets = .zero
        inset.top = set[.top] ?? top
        inset.bottom = set[.bottom] ?? bottom
        inset.left = set[.left] ?? left
        inset.right = set[.right] ?? right
        return inset
    }
}
#endif
#endif
