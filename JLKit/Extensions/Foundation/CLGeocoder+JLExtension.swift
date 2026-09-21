//
//  CLGeocoder+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 4. 27..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import CoreLocation
import Foundation

public extension CLGeocoder {
    /// 유효하지 않은 좌표는 호출 스레드에서 오류와 함께 즉시 완료합니다.
    static func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion: ((CLPlacemark?, Error?) -> Void)? = nil) {
        guard CLLocationCoordinate2DIsValid(coordinate) else {
            completion?(nil, NSError(domain: kCLErrorDomain, code: CLError.Code.locationUnknown.rawValue))
            return
        }

        let location = CLLocation(coordinate: coordinate)

        let goecoder = CLGeocoder()
        goecoder.reverseGeocodeLocation(location) { pacemarks, error in
            completion?(pacemarks?.first, error)
        }
    }
}
