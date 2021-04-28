//
//  CaseIterable+Extension.swift
//  MemoWidget
//
//  Created by 장석용 on 2020/10/26.
//  Copyright © 2020 장석용. All rights reserved.
//

import Foundation

extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    public func previous() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = all.index(before: idx)
        return all[previous < all.startIndex ? all.index(before: all.endIndex) : previous]
    }

    public func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}
