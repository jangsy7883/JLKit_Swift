//
//  CaseIterableDefaultsLast.swift
//  TheDayCouple
//
//  Created by 장석용 on 2020/03/27.
//  Copyright © 2020 TheDayBefore. All rights reserved.
//

import Foundation

public protocol CaseIterableDefaultsLast: Decodable & CaseIterable & RawRepresentable where Self.RawValue: Decodable, Self.AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsLast {
    public init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.last!
    }
}

public protocol CaseIterableDefaultsFirst: Decodable & CaseIterable & RawRepresentable where Self.RawValue: Decodable, Self.AllCases: BidirectionalCollection { }

extension CaseIterableDefaultsFirst {
    public init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.allCases.first!
    }
}
