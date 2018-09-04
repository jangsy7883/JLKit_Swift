//
//  SKProduct+JLextension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    var currencyPrice :String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        
        return formatter.string(from: price)
    }
}
