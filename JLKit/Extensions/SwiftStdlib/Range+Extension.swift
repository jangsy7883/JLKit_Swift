//
//  Range+Extension.swift
//  TheDayBefore
//
//  Created by 장석용 on 2020/11/03.
//  Copyright © 2020 TheDayBefore. All rights reserved.
//

import Foundation

public extension ClosedRange where Element == Int {
    var values: [Element] {
        return compactMap { $0 }
    }
}
