//
//  URL+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 19..
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

extension URL {
    public var parameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

    public func withParameters(parameters: [String: Any]) -> Foundation.URL {
        guard parameters.isEmpty == false else {return self}

        var queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            if let value = value as? String {
                queryItems.append(URLQueryItem(name: key, value: value))
            } else if let value = value as? NSNumber {
                queryItems.append(URLQueryItem(name: key, value: value.stringValue))
            }
        }
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)//URLComponents(string:self.absoluteString)
        components?.queryItems = queryItems
        return components?.url ?? self
    }
    
    func parameterValue(for key: String) -> String? {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
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
