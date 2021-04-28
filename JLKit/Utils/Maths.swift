//
//  Maths.swift
//  TheCouple
//
//  Created by 장석용 on 2021/02/26.
//  Copyright © 2021 TheDayBefore. All rights reserved.
//

import Foundation

func max<T>(_ x: T?, _ y: T?) -> T? where T: Comparable {
    if let x = x, let y = y {
        return max(x, y)
    } else {
        return x ?? y
    }
}

func min<T>(_ x: T?, _ y: T?) -> T? where T: Comparable {
    if let x = x, let y = y {
        return min(x, y)
    } else {
        return x ?? y
    }
}
