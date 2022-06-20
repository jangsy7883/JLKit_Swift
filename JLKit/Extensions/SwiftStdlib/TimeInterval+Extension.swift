//
//  TimeInterval+Extension.swift
//  TheDayBefore
//
//  Created by 장석용 on 10/09/2019.
//  Copyright © 2019 TheDayBefore. All rights reserved.
//

import Foundation

public extension TimeInterval {
    static func minutes(_ minutes: Double) -> TimeInterval {
        return TimeInterval(minutes: minutes)
    }

    static func hours(_ hours: Double) -> TimeInterval {
        return TimeInterval(hours: hours)
    }

    init(minutes: Double) {
        self.init(minutes * 60)
    }

    init(hours: Double) {
        self.init(minutes: hours * 60)
    }

    var minutes: Double {
        return self / 60.0
    }

    var hours: Double {
        return minutes / 60.0
    }
}

public extension TimeInterval {
    var databaseValue: TimeInterval { ceil(self) }
}
