//
//  Int64+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2020/06/29.
//  Copyright © 2020 Woody. All rights reserved.
//

import Foundation

extension Int64 {
    public var intValue: Int? {
        return Int(exactly: self)
    }

    public var string: String {
        return String(self)
    }
}
