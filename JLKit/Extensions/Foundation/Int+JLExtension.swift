//
//  Int+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Int {    
    public static func random(min:Int, max:Int) -> Int {
        let form = max - min + 1
        return Int(UInt32(min) + arc4random_uniform(UInt32(form)))
    }
}


extension Int {
    public var decimalString: String {
        return NumberFormatter.decimal.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
