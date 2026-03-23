//
//  CLLocation+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 2. 26..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import CoreLocation
import Foundation

public extension CLLocationCoordinate2D {
    func equalTo(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return latitude == coordinate.latitude && longitude == coordinate.longitude
    }

    func distanceFrom(_ coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let toLocation = CLLocation(coordinate: self)
        let fromLocation = CLLocation(coordinate: coordinate)

        return toLocation.distance(from: fromLocation)
    }
}

public extension CLLocation {
    @objc convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
