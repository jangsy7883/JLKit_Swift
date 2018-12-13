//
//  NSNumber+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 26..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension NSNumber {
    @objc public func localizedString(numberStyle:NumberFormatter.Style) -> String {
        return NumberFormatter.localizedString(from: self, number: numberStyle)
    }

    @objc public func stringBy(roundingMode: NumberFormatter.RoundingMode, maximumFractionDigits: Int) -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.roundingMode = roundingMode
        return formatter.string(from: self)
    }
}
