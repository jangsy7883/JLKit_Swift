//
//  Array+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 1. 16..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Array {
    
    //MARK: - Subscript
    
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
    
    public subscript (safe range: ClosedRange<Index>) -> ArraySlice<Element> {
        let from = Swift.max(startIndex, range.lowerBound)
        let to = Swift.min(endIndex, range.upperBound)
        return self[from ..< to]
    }
    
    public subscript (safe range: Range<Index>) -> ArraySlice<Element> {
        let from = Swift.max(startIndex, range.lowerBound)
        let to = Swift.min(endIndex, range.upperBound)
        return self[from ..< to]
    }

    //MARK: - Shuffle
    
    public mutating func shuffle() {
        guard self.count >= 1 else { return }
        
        for i in (1..<self.count).reversed() {
            let j = (0...i).randomElement()!
            self.swapAt(j, i)
        }
    }
    
    public var shuffled: [Element] {
        var elements = self
        elements.shuffle()
        return elements
    }
        
    //MARK: - Sort
    
    public func sorted<T: Comparable>(by compare: (Element) -> T, asc ascendant: Bool = true) -> Array {
        return self.sorted {
            if ascendant {
                return compare($0) < compare($1)
            }

            return compare($0) > compare($1)
        }
    }

}
