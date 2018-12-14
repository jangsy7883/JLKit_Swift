//
//  Array+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 16..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        get{
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let value = newValue else { return }
            guard indices ~= index else { return }
            
            self[index] = value
        }
    }
}
