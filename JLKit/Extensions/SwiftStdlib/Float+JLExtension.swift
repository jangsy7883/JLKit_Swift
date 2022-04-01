//
//  CGFloat+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 1. 12..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

#if canImport(UIKit)
import UIKit
#endif

public extension Float {
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
    
    #if canImport(UIKit)
    static func pixel(_ value: CGFloat = 1.0) -> CGFloat {
        return value/UIScreen.main.scale
    }
    #endif
}

#if canImport(CoreGraphics)
import CoreGraphics

public extension Float {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}

public extension CGFloat {
    #if canImport(UIKit)
    static func pixel(_ value: CGFloat = 1.0) -> CGFloat {
        return value/UIScreen.main.scale
    }
#endif
    var int: Int {
        return Int(self)
    }
    
    var double: Double {
        return Double(self)
    }
}
#endif
