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
    func jsonFromFile(
        atPath path: String,
        readingOptions: JSONSerialization.ReadingOptions = .allowFragments) throws -> [String: Any]? {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
            
            return json as? [String: Any]
        }
}

extension FileManager {
    public struct CreateConfig {
        public let createIntermediateDirectories: Bool
        public let attributes: [FileAttributeKey : Any]?
        
        public init(createIntermediateDirectories: Bool = true, attributes: [FileAttributeKey : Any]? = nil) {
            self.createIntermediateDirectories = createIntermediateDirectories
            self.attributes = attributes
        }
    }
    
    //MARK : - Directory Path
    
    public func directoryURL(for directory: FileManager.SearchPathDirectory, paths: [String]? = nil) -> URL? {
        guard let documentsPath = urls(for: directory, in: .userDomainMask).first else { return nil }
        if let paths = paths, !paths.isEmpty {
            let path = paths.joined(separator: "/")
            return documentsPath.appendingPathComponent(path)
        }else {
            return documentsPath
        }
    }
    
    public func directoryPath(for directory: FileManager.SearchPathDirectory, path: String? = nil, filename: String? = nil) -> URL? {
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

    public func containerURL(for groupIdentifier: String, paths: [String], createDirectory createConfig:CreateConfig? = CreateConfig()) -> URL? {
        guard let documentsPath = containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)  else { return nil }
        let path = paths.joined(separator: "/")
        let result = documentsPath.appendingPathComponent(path)
        
        if let config = createConfig, fileExists(atPath: documentsPath.path) == false {
            try? createDirectory(at: result, withIntermediateDirectories: config.createIntermediateDirectories, attributes: config.attributes)
        }
        
        return result
    }
    
    //MARK : - Group Directory Path
    
    public func groupDirectoryPath(_ groupIdentifier: String, path: String? = nil, filename: String? = nil) -> URL? {
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
