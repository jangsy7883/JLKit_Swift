//
//  Collection+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 9. 4..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Collection {
    public func JSONString(_ options: JSONSerialization.WritingOptions = []) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        guard let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) else { return nil }
        return JSONString
    }
}
