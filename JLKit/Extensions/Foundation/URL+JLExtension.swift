//
//  URL+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 2. 19..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension URL {
    public var parameters: [String: String]? {
        guard let components = NSURLComponents(url: self, resolvingAgainstBaseURL: false) else { return nil }
        guard let items = components.queryItems, items.isEmpty == false else { return nil }

        var parameters = [String: String]()
        for item in items {
            if let value = item.value {
                parameters[item.name] = value
            }
        }
        return parameters
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
}
