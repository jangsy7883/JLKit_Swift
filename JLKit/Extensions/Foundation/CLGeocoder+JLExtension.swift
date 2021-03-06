//
//  CLGeocoder+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 4. 27..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation
import CoreLocation

extension CLGeocoder {
    @objc public static func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: ((CLPlacemark?, Error?) -> Void)? = nil) {
        guard CLLocationCoordinate2DIsValid(coordinate) == true else { return }
        let location = CLLocation(coordinate: coordinate)

        let goecoder = CLGeocoder()
        goecoder.reverseGeocodeLocation(location) { (pacemarks, error) in
            completion?(pacemarks?.first, error)
        }
    }
}
