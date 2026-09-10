import XCTest
import JLKit_Swift

final class IntRandomTests: XCTestCase {
    func testNegativeAndMixedRanges() {
        for range in [-10 ... -1, -2 ... 2, 0 ... 10, 1 ... 10] {
            for _ in 0..<100 {
                XCTAssertTrue(range.contains(Int.random(min: range.lowerBound, max: range.upperBound)))
            }
        }
    }

    func testSingleValueRangesIncludeBothBounds() {
        for value in [Int.min, -1, 0, 1, Int.max] {
            XCTAssertEqual(Int.random(min: value, max: value), value)
        }
    }

    func testExtremeRangesDoNotOverflow() {
        let ranges = [
            Int.min ... Int.max,
            Int.min ... (Int.min + 10),
            (Int.max - 10) ... Int.max,
            Int.min ... 0,
            0 ... Int.max
        ]
        for range in ranges {
            for _ in 0..<100 {
                XCTAssertTrue(range.contains(Int.random(min: range.lowerBound, max: range.upperBound)))
            }
        }
    }
}
