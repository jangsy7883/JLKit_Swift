//
//  FileManager+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 8. 27..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

#if canImport(Foundation)
import Foundation

public extension FileManager {
    func jsonFromFile(atPath path: String,
                      readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)

            return json as? [String: Any]
        }
}

public extension FileManager {
    struct CreateConfig {
        public let createIntermediateDirectories: Bool
        public let attributes: [FileAttributeKey: Any]?

        public init(createIntermediateDirectories: Bool = true, attributes: [FileAttributeKey: Any]? = nil) {
            self.createIntermediateDirectories = createIntermediateDirectories
            self.attributes = attributes
        }
    }

    // MARK: - Directory Path

    func directoryURL(for directory: FileManager.SearchPathDirectory, paths: [String]? = nil) -> URL? {
        guard let documentsPath = urls(for: directory, in: .userDomainMask).first else { return nil }

        if let paths = paths, !paths.isEmpty {
            let path = paths.joined(separator: "/")
            return documentsPath.appendingPathComponent(path)
        } else {
            return documentsPath
        }
    }

    func directoryPath(for directory: FileManager.SearchPathDirectory, path: String? = nil, filename: String? = nil) -> URL? {
        if let documentsDirectory = urls(for: directory, in: .userDomainMask).first {
            var documentsPath = documentsDirectory
            if let path = path, path.isEmpty == false {
                documentsPath = documentsDirectory.appendingPathComponent(path)
            }
            if fileExists(atPath: documentsPath.path) == false {
                try? createDirectory(atPath: documentsPath.path, withIntermediateDirectories: true, attributes: nil)
            }
            if let filename = filename {
                return documentsPath.appendingPathComponent(filename)
            } else {
                return documentsPath
            }
        }
        return nil
    }

    /// - Parameter createConfig: 전달하면 반환 경로의 디렉터리가 없을 때 생성한다.
    ///   기본값은 `nil`(생성 안 함) — 속성 지정이 필요한 호출부가 `URL.createDirectory(attributes:)`를
    ///   체이닝하는 기존 패턴과 충돌하지 않도록 생성 여부는 명시적으로 선택한다.
    func containerURL(for groupIdentifier: String, paths: [String], createDirectory createConfig: CreateConfig? = nil) -> URL? {
        guard let containerPath = containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) else { return nil }

        let path = paths.joined(separator: "/")
        let result = path.isEmpty ? containerPath : containerPath.appendingPathComponent(path)

        if let config = createConfig, fileExists(atPath: result.path) == false {
            try? createDirectory(at: result, withIntermediateDirectories: config.createIntermediateDirectories, attributes: config.attributes)
        }

        return result
    }

    // MARK: - Group Directory Path

    func groupDirectoryPath(_ groupIdentifier: String, path: String? = nil, filename: String? = nil) -> URL? {
        if let documentsDirectory = containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier) {
            var documentsPath = documentsDirectory
            if let path = path, path.isEmpty == false {
                documentsPath = documentsDirectory.appendingPathComponent(path)
            }
            if fileExists(atPath: documentsPath.path) == false {
                try? createDirectory(atPath: documentsPath.path, withIntermediateDirectories: true, attributes: nil)
            }

            if let filename = filename {
                return documentsPath.appendingPathComponent(filename)
            } else {
                return documentsPath
            }
        }
        return nil
    }
}
#endif
