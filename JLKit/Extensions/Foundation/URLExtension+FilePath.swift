//
//  URL+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 19..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension URL {
    public func createDirectory(withIntermediateDirectories createIntermediates: Bool = true, attributes: [FileAttributeKey : Any]? = nil) -> URL? {
        let manager = FileManager.default
        if manager.fileExists(atPath: path) == false {
            do {
                try manager.createDirectory(at: self, withIntermediateDirectories: createIntermediates, attributes: attributes)
            }
            catch {
                return nil
            }
        }
        return self
    }
    
    public func validFileURL() -> URL? {
        if FileManager.default.fileExists(atPath: path) {
            return self
        }
        return nil
    }
}

extension URL {
    public var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    public var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    public var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    public var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
