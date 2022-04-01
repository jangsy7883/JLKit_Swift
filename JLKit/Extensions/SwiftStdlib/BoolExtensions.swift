//
//  BoolExtensions.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2022/04/01.
//  Copyright © 2022 Woody. All rights reserved.
//


public extension Bool {
    var int: Int {
        return self ? 1 : 0
    }

    var string: String {
        return self ? "true" : "false"
    }
}
