//
//  IndexSet+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension IndexSet {
    public var array: [Int] {
        return self.map { return $0 }
    }
}
