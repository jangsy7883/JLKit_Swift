//
//  Int+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public extension Int {
    /// min과 max를 포함하는 범위에서 난수를 반환합니다. min <= max여야 합니다.
    static func random(min: Int, max: Int) -> Int {
        return Int.random(in: min...max)
    }

    var decimalString: String {
        return NumberFormatter.decimal.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    var uInt: UInt {
        return UInt(self)
    }

    var double: Double {
        return Double(self)
    }

    var float: Float {
        return Float(self)
    }

    var string: String {
        return String(self)
    }
}

#if canImport(CoreGraphics)
import CoreGraphics

public extension Int {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

#endif
