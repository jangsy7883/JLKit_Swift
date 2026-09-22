//
//  Array+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 1. 16..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public extension Array {
    // MARK: - Subscript

    subscript(safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let value = newValue else { return }
            guard indices ~= index else { return }

            self[index] = value
        }
    }

    /// 배열과 겹치는 범위만 반환하며, upperBound의 원소도 포함합니다.
    subscript(safe range: ClosedRange<Index>) -> ArraySlice<Element> {
        let from = Swift.min(endIndex, Swift.max(startIndex, range.lowerBound))
        let to: Index
        if range.upperBound < startIndex {
            to = startIndex
        } else if range.upperBound >= endIndex {
            to = endIndex
        } else {
            to = range.upperBound + 1
        }
        return self[from ..< to]
    }

    subscript(safe range: Range<Index>) -> ArraySlice<Element> {
        let from = Swift.min(endIndex, Swift.max(startIndex, range.lowerBound))
        let to = Swift.min(endIndex, Swift.max(startIndex, range.upperBound))
        return self[from ..< to]
    }

    // MARK: - Sort

    func sorted<T: Comparable>(by compare: (Element) -> T, asc ascendant: Bool = true) -> Array {
        return sorted {
            if ascendant {
                return compare($0) < compare($1)
            }

            return compare($0) > compare($1)
        }
    }

    // MARK: -  Division

    func division(length: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: length).map {
            Array(self[$0 ..< Swift.min($0 + length, count)])
        }
    }
}

public extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        return reduce(into: [Element]()) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }

    func filterDuplicates(includeElement: (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
        var results = [Element]()

        forEach { element in
            let existingElements = results.filter {
                includeElement(element, $0)
            }
            if existingElements.isEmpty {
                results.append(element)
            }
        }
        return results
    }

    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = firstIndex(of: element) { move(from: oldIndex, to: newIndex) }
    }

    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return swapAt(oldIndex, newIndex) }
        insert(remove(at: oldIndex), at: newIndex)
    }
}
