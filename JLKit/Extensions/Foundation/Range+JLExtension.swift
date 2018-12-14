//
//  Range+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 8. 16..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Range where Bound == String.Index {
    public var nsRange: NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}
