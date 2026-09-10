import XCTest
import JLKit_Swift

final class ArraySafeRangeTests: XCTestCase {
    func testClosedRangeIncludesUpperBound() {
        let values = [10, 20, 30]
        XCTAssertEqual(Array(values[safe: 0...1]), [10, 20])
        XCTAssertEqual(Array(values[safe: 1...1]), [20])
        XCTAssertEqual(Array(values[safe: 2...2]), [30])
    }

    func testRangesReturnOnlyElementsWithMatchingIndices() {
        // 빈 배열, 범위 밖, 부분 교집합, 빈 반열린 범위를 함께 검증한다.
        for count in 0...5 {
            let values = Array(0..<count)
            for lower in -3...8 {
                for upper in lower...8 {
                    let closed = lower...upper
                    let halfOpen = lower..<upper
                    XCTAssertEqual(Array(values[safe: closed]), values.filter { closed.contains($0) })
                    XCTAssertEqual(Array(values[safe: halfOpen]), values.filter { halfOpen.contains($0) })
                }
            }
        }
    }

    func testExtremeBoundsDoNotOverflow() {
        for values in [[], [10, 20, 30]] {
            XCTAssertEqual(Array(values[safe: Int.min...Int.max]), values)
            XCTAssertEqual(Array(values[safe: Int.min..<Int.max]), values)
            XCTAssertTrue(values[safe: Int.min...Int.min].isEmpty)
            XCTAssertTrue(values[safe: Int.max...Int.max].isEmpty)
            XCTAssertTrue(values[safe: Int.min..<Int.min].isEmpty)
            XCTAssertTrue(values[safe: Int.max..<Int.max].isEmpty)
        }
    }

    func testSlicePreservesOriginalIndices() {
        let slice = [10, 20, 30][safe: 1...2]
        XCTAssertEqual(slice.startIndex, 1)
        XCTAssertEqual(slice.endIndex, 3)
        XCTAssertEqual(slice[1], 20)
    }
}
