//
//  FileManager+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 8. 27..
//  Copyright © 2018년 JLKit_Swift. All rights reserved.
//

import Foundation

extension FileManager {
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
