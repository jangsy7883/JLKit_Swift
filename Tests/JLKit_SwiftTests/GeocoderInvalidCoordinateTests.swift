import CoreLocation
import Foundation
import XCTest
import JLKit_Swift

final class GeocoderInvalidCoordinateTests: XCTestCase {
    func testOutOfRangeCoordinatesCompleteWithError() {
        for coordinate in [
            CLLocationCoordinate2D(latitude: -91, longitude: 0),
            CLLocationCoordinate2D(latitude: 91, longitude: 0),
            CLLocationCoordinate2D(latitude: 0, longitude: -181),
            CLLocationCoordinate2D(latitude: 0, longitude: 181)
        ] {
            assertInvalidCoordinateCompletes(coordinate)
        }
    }

    func testNonFiniteCoordinatesCompleteWithError() {
        for value in [Double.nan, .infinity, -.infinity] {
            assertInvalidCoordinateCompletes(CLLocationCoordinate2D(latitude: value, longitude: 0))
            assertInvalidCoordinateCompletes(CLLocationCoordinate2D(latitude: 0, longitude: value))
        }
    }

    func testInvalidCoordinateAllowsOmittedCompletion() {
        CLGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: 91, longitude: 0))
    }

    private func assertInvalidCoordinateCompletes(
        _ coordinate: CLLocationCoordinate2D, file: StaticString = #filePath, line: UInt = #line
    ) {
        var calls = 0
        CLGeocoder.reverseGeocodeCoordinate(coordinate) { placemark, error in
            calls += 1
            XCTAssertNil(placemark, file: file, line: line)
            XCTAssertNotNil(error, file: file, line: line)
            let nsError = error as NSError?
            XCTAssertEqual(nsError?.domain, kCLErrorDomain, file: file, line: line)
            XCTAssertEqual(nsError?.code, CLError.Code.locationUnknown.rawValue, file: file, line: line)
        }
        XCTAssertEqual(calls, 1, file: file, line: line)
    }
}
