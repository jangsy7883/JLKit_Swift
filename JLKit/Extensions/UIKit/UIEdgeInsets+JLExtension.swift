//
//  UIEdgeInsets+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 19/06/2019.
//  Copyright © 2019 Woody. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    public enum Position {
        case top
        case bottom
        case left
        case right
    }
    
    public func insetsBySet(_ set: [Position: CGFloat]) -> UIEdgeInsets {
        var inset: UIEdgeInsets = .zero
        inset.top = set[.top] ?? self.top
        inset.bottom = set[.bottom] ?? self.bottom
        inset.left = set[.left] ?? self.left
        inset.right = set[.right] ?? self.right
        return inset
    }
}
