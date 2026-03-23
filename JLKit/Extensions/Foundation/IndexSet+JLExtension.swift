//
//  IndexSet+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public extension IndexSet {
    var array: [Int] {
        return map { $0 }
    }
}
