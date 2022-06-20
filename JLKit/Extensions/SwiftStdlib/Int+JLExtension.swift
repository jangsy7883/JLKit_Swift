//
//  Int+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

#if canImport(CoreGraphics)
import CoreGraphics
#endif

public extension Int {    
    static func random(min:Int, max:Int) -> Int {
        let form = max - min + 1
        return Int(UInt32(min) + arc4random_uniform(UInt32(form)))
    }
}

public extension Int {
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

     #if canImport(CoreGraphics)
     var cgFloat: CGFloat {
         return CGFloat(self)
     }
     #endif
}
