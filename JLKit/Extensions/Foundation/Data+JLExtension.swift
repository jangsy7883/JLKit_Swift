//
//  Data+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 2020/06/29.
//  Copyright © 2020 Woody. All rights reserved.
//

#if canImport(Foundation)
import Foundation

public extension Data {
    func byteString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = units
        bcf.countStyle = .file
        
        return bcf.string(fromByteCount: Int64(count))
    }

    func string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }
    
    func jsonObject(options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
}

#endif
