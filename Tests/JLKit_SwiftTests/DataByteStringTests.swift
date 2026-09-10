import Foundation
import XCTest
import JLKit_Swift

final class DataByteStringTests: XCTestCase {
    func testEachCountStyleMatchesRequestedFormatterStyle() {
        let data = Data(repeating: 0, count: 1_500_000)
        for style: ByteCountFormatter.CountStyle in [.file, .memory, .decimal, .binary] {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = .useAll
            formatter.countStyle = style
            XCTAssertEqual(data.byteString(countStyle: style), formatter.string(fromByteCount: Int64(data.count)))
        }
        XCTAssertNotEqual(data.byteString(countStyle: .decimal), data.byteString(countStyle: .binary))
    }

    func testDefaultRemainsFileStyle() {
        let data = Data(repeating: 0, count: 1024)
        XCTAssertEqual(data.byteString(), ByteCountFormatter.string(fromByteCount: 1024, countStyle: .file))
    }

    func testAllowedUnitsArePreservedWithBinaryStyle() {
        let data = Data(repeating: 0, count: 1_500_000)
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useKB
        formatter.countStyle = .binary
        XCTAssertEqual(data.byteString(units: .useKB, countStyle: .binary),
                       formatter.string(fromByteCount: Int64(data.count)))
    }

    func testEmptyData() {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = .useAll
        formatter.countStyle = .binary
        XCTAssertEqual(Data().byteString(countStyle: .binary), formatter.string(fromByteCount: 0))
    }
}
