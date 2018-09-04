//
//  Array+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 16..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        // iOS 9 or later
        return indices ~= index ? self[index] : nil
        // iOS 8 or earlier
        // return startIndex <= index && index < endIndex ? self[index] : nil
        // return 0 <= index && index < self.count ? self[index] : nil
    }
}
