//
//  Data+Extension.swift
//  TheDayBefore
//
//  Created by 장석용 on 2020/12/07.
//  Copyright © 2020 TheDayBefore. All rights reserved.
//

import Foundation

extension Data {
    
    public func string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
}
