//
//  Bundle.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 14..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension Bundle {

    @objc public var appVersion: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String ?? nil
    }
    @objc public var buildVersion: String? {
        return self.infoDictionary?[kCFBundleVersionKey as String] as? String ?? nil
    }
 
    public func compareVersion(_ target: String!) -> ComparisonResult {
        var result: ComparisonResult = .orderedSame
        guard let version = self.appVersion else { return result }

        var versionComponents: [String] = version.split(separator: ".").map {String($0)}
        var targetComponents: [String] = target.split(separator: ".").map {String($0)}

        if versionComponents.count != targetComponents.count {
            let maxCount = max(versionComponents.count, targetComponents.count)

            if versionComponents.count < maxCount {
                let elements = [String](repeatElement("0", count: maxCount-versionComponents.count))
                versionComponents.append(contentsOf: elements)
            } else {
                let elements = [String](repeatElement("0", count: maxCount-targetComponents.count))
                targetComponents.append(contentsOf: elements)
            }

            let _version = versionComponents.joined(separator: ".")
            let _target = targetComponents.joined(separator: ".")

            result = _version.compare(_target, options: .numeric)
        } else {
            result = version.compare(target, options: .numeric)
        }

        return result
    }
}
