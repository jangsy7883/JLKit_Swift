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

    //MARK: -  Division
    
    public func division(length: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: length).map {
            Array(self[$0 ..< Swift.min($0 + length, count)])
        }
    }
}

public extension Array where Element: Equatable {
    mutating func removeDuplicates() -> [Element] {
        self = reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
        return self
    }
    
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
    }

    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
