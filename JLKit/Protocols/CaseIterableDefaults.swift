//
//  CaseIterableDefaults.swift
//  TheDayCouple
//
//  Created by 장석용 on 2020/03/27.
//  Copyright © 2020 TheDayBefore. All rights reserved.
//

import Foundation

// MARK: - CaseIterableDefaultsLast

public protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable where Self.RawValue: Decodable, Self.AllCases: BidirectionalCollection {}

public extension CaseIterableDefaultsLast {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

// MARK: - CaseIterableDefaultsFirst

public protocol CaseIterableDefaultsFirst: Decodable & CaseIterable & RawRepresentable where Self.RawValue: Decodable, Self.AllCases: BidirectionalCollection {}

public extension CaseIterableDefaultsFirst {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.first!
    }
}
