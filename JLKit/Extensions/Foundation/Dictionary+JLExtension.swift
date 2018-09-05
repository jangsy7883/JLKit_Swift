//
//  Dictionary+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 3. 20..
//  Copyright © 2018년 Goodoc. All rights reserved.
//

import Foundation

extension Dictionary {
    
   public subscript(keyPath keyPath: String) -> Any? {
        var keys = keyPath.components(separatedBy: ".")
        guard let first = keys.first as? Key else { return nil }
        guard let value = self[first] else { return nil }
        keys.remove(at: 0)
        if !keys.isEmpty, let subDict = value as? [AnyHashable: Any] {
            let rejoined = keys.joined(separator: ".")
            return subDict[keyPath: rejoined]
        }
        return value
    }
    
    public func valueForKeys(_ keys: [Key]) -> Any? {
        for key in keys {
            if let path = key as? String, let value = self[keyPath: path] {
                return value
            }
        }
        return nil
    }
}
