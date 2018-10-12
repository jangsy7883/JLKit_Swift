//
//  UIFont+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 2. 7..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import UIKit

extension UIFont {
    public func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else { return self }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
