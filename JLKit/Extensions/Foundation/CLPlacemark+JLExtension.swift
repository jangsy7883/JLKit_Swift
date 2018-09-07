//
//  CLPlacemark+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 4. 27..
//  Copyright © 2018년 Goodoc. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    @objc public var localizedAddress: String? {
        guard let formattedAddressLines = addressDictionary?["FormattedAddressLines"] as? [String], formattedAddressLines.isEmpty == false else { return nil }
        var value = formattedAddressLines.first
        if let code = postalCode {
            value =  value?.replacingOccurrences(of: code, with: "")
        }

        return value?.trimmedString
    }
}
