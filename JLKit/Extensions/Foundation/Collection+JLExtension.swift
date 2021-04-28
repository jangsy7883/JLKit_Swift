//
//  Collection+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Collection {
    
    //MARK:
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    //MARK: - JSON
    
    public func JSONString(_ options: JSONSerialization.WritingOptions = []) -> String? {
        guard let jsonData = JSONData(options) else { return nil }
        guard let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) else { return nil }
        return JSONString
    }
    
    public func JSONData(_ options: JSONSerialization.WritingOptions = []) -> Data? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return jsonData
    }
    
    //MARK: - Random
    
    public func randomElements(_ count: UInt) -> [Element] {
        let sampleCount = Swift.min(numericCast(count), self.count)
        
        var elements = Array(self)
        var samples: [Element] = []
        
        while samples.count < sampleCount {
            let idx = (0..<elements.count).randomElement()!
            samples.append(elements.remove(at: idx))
        }
        
        return samples
    }
}
