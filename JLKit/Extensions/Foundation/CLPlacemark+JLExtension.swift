//
//  CLPlacemark+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 4. 27..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts

extension CLPlacemark {
    @objc public var formattedAddress: String? {
        var value: String?

        if #available(iOS 11.0, *), let postalAddress = postalAddress {
            let address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
            value = address.replacingOccurrences(of: "\n", with: " ").trimmedString
        } else if let formattedAddressLines = addressDictionary?["FormattedAddressLines"] as? [String], let address = formattedAddressLines.first {            
            value = address.trimmedString
        }

        if let code = postalCode {
            value =  value?.replacingOccurrences(of: code, with: "")
        }
        
        return value
    }
}
