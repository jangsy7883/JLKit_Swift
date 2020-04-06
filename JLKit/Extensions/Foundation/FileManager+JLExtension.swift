//
//  FileManager+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 8. 27..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension URL {
    public func createDirectory() -> URL? {
        let manager = FileManager.default
        if manager.fileExists(atPath: path) == false {
            do {
                try manager.createDirectory(at: self, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                return nil
            }
        }
        return self
    }
    
    public func vaildFileURL() -> URL? {
        if FileManager.default.fileExists(atPath: self.path) {
            return self
        }
        return nil
    }
}

extension FileManager {

    //MARK : - Directory Path
    
    public func fileURL(for directory: FileManager.SearchPathDirectory, paths: [String]) -> URL? {
        guard let documentsPath = urls(for: directory, in: .userDomainMask).first else { return nil }
        let path = paths.joined(separator: "/")
        return documentsPath.appendingPathComponent(path)
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
    
    public func containerURL(for groupIdentifier: String, paths: [String], createDirectory isCreate:Bool = true) -> URL? {
        guard let documentsPath = containerURL(forSecurityApplicationGroupIdentifier: groupIdentifier)  else { return nil }
        let path = paths.joined(separator: "/")
        let result = documentsPath.appendingPathComponent(path)
        
        if isCreate, fileExists(atPath: documentsPath.path) == false {
            try? createDirectory(at: result, withIntermediateDirectories: true, attributes: nil)
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
