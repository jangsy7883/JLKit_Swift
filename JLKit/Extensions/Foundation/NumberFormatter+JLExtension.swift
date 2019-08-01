//
//  NumberFormatter+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 19/06/2019.
//  Copyright © 2019 Woody. All rights reserved.
//

import Foundation

extension NumberFormatter {    
    public static func string(value: Int, numberStyle:NumberFormatter.Style) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}

