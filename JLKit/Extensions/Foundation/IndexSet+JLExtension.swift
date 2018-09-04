//
//  IndexSet+JLExtension.swift
//  JLKit_Swift
//
//  Created by Woody on 2018. 9. 4..
//  Copyright © 2018년 Woody. All rights reserved.
//

import Foundation

extension IndexSet {

    var array: [Int] {
        return self.map { return $0 }
    }
}
