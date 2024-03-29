//
//  CLPlacemark+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 4. 27..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if os(iOS)
import Foundation
import CoreLocation
import Contacts

public extension CLPlacemark {
    @objc var formattedAddress: String? {
        var value: String?

        if let postalAddress = postalAddress {
            let address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
            value = address.replacingOccurrences(of: "\n", with: " ").trimmed
        }

        if let code = postalCode {
            value =  value?.replacingOccurrences(of: code, with: "")
        }
        
        return value
    }
}
#endif
