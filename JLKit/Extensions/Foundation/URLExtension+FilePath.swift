//
//  URLExtension+FilePath.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 19..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public extension URL {
    func createDirectory(withIntermediateDirectories createIntermediates: Bool = true, attributes: [FileAttributeKey: Any]? = nil) -> URL? {
        let manager = FileManager.default
        if manager.fileExists(atPath: path) == false {
            do {
                try manager.createDirectory(at: self, withIntermediateDirectories: createIntermediates, attributes: attributes)
            } catch {
                return nil
            }
        }
        return self
    }

    func validFileURL() -> URL? {
        if FileManager.default.fileExists(atPath: path) {
            return self
        }
        return nil
    }

    var isExcludedFromBackup: Bool {
        (try? resourceValues(forKeys: [.isExcludedFromBackupKey]))?.isExcludedFromBackup ?? false
    }

    /// iCloud/iTunes 백업 제외 여부를 설정한다. 대상 파일/디렉터리가 이미 존재해야 한다.
    /// - Returns: 성공 시 self (체이닝용), 실패 시 nil
    @discardableResult func setExcludedFromBackup(_ excluded: Bool = true) -> URL? {
        var url = self
        var values = URLResourceValues()
        values.isExcludedFromBackup = excluded
        do {
            try url.setResourceValues(values)
        } catch {
            return nil
        }
        return self
    }
}

public extension URL {
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
    }
}
