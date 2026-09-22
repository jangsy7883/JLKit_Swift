//
//  Dictionary+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 3. 20..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public extension Dictionary {
    /// 점으로 구분한 문자열 키 경로 전체가 존재할 때만 값을 반환합니다.
    subscript(keyPath keyPath: String) -> Any? {
        var keys = keyPath.components(separatedBy: ".")
        guard let first = keys.first as? Key else { return nil }
        guard let value = self[first] else { return nil }

        keys.remove(at: 0)
        guard !keys.isEmpty else { return value }
        guard let subDict = value as? [AnyHashable: Any] else { return nil }
        let rejoined = keys.joined(separator: ".")
        return subDict[keyPath: rejoined]
    }

    /// 순서대로 조회해 첫 값을 반환합니다. 문자열 키는 기존처럼 점 구분 경로로 해석합니다.
    func valueForKeys(_ keys: [Key]) -> Any? {
        for key in keys {
            let value: Any?
            if let path = key as? String {
                value = self[keyPath: path]
            } else {
                value = self[key]
            }
            if let value = value {
                return value
            }
        }
        return nil
    }
}
