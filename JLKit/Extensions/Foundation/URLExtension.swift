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

public extension URL {
    func appendingParameters(_ parameters: [String: String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        let existingItems = components?.queryItems ?? []
        components?.queryItems = existingItems + parameters
            .map { URLQueryItem(name: $0, value: $1) }
        return components?.url ?? self
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
}
