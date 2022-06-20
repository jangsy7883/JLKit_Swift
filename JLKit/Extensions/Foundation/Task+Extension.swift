//
//  Task+Extension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2022/06/20.
//  Copyright © 2022 Woody. All rights reserved.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
