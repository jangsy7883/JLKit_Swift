//
//  CLLocation+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 2. 26..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    public func equalTo(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
    }

    public func distanceFrom(_ coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let toLocation = CLLocation(coordinate: self)
        let fromLocation = CLLocation(coordinate: coordinate)

        return toLocation.distance(from: fromLocation)
    }
}

extension CLLocation {
    @objc public convenience init(coordinate:CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
