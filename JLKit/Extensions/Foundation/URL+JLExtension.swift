//
//  URL+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 19..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public extension URL {
    var domain: String? {
        guard let scheme = scheme else { return nil }
        guard let host = host else { return nil }
        if let port = port {
            return "\(scheme)://\(host):\(port)"
        } else {
            return "\(scheme)://\(host)"
        }
    }
}

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
    
    public func vaildFileURL() -> URL? {
        if FileManager.default.fileExists(atPath: path) {
            return self
        }
        return nil
    }
}

public extension URL {
    func appendingParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + parameters
            .map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url!
    }

    mutating func appendParameters(_ parameters: [String: String]) {
        self = appendingParameters(parameters)
    }
    
    var parameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }

    func withParameters(parameters: [String: Any]) -> URL {
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
