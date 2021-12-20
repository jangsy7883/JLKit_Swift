//
//  CaseIterable+Extension.swift
//  MemoWidget
//
//  Created by 장석용 on 2020/10/26.
//  Copyright © 2020 장석용. All rights reserved.
//

import Foundation

public extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    func previous() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = all.index(before: idx)
        return all[previous < all.startIndex ? all.index(before: all.endIndex) : previous]
    }

    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}

public extension Collection where Element: Equatable {
    func element(after element: Element, wrapping: Bool = false) -> Element? {
        if let index = self.firstIndex(of: element) {
            let followingIndex = self.index(after: index)
            if followingIndex < self.endIndex {
                return self[followingIndex]
            } else if wrapping {
                return self[self.startIndex]
            }
        }
        return nil
    }
}

public extension BidirectionalCollection where Element: Equatable {
    func element(before element: Element, wrapping: Bool = false) -> Element? {
        if let index = self.firstIndex(of: element) {
            let precedingIndex = self.index(before: index)
            if precedingIndex >= self.startIndex {
                return self[precedingIndex]
            } else if wrapping {
                return self[self.index(before: self.endIndex)]
            }
        }
        return nil
    }
}
