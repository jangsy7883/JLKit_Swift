import XCTest
import JLKit_Swift

final class PreviousElementTests: XCTestCase {
    func testStringStartBoundaryAndWrapping() {
        let text = "가👨‍👩‍👧‍👦끝"
        XCTAssertNil(text.element(before: "가"))
        XCTAssertEqual(text.element(before: "가", wrapping: true), "끝")
        XCTAssertEqual(text.element(before: "👨‍👩‍👧‍👦"), "가")
        XCTAssertEqual(text.element(before: "끝", wrapping: true), "👨‍👩‍👧‍👦")
    }

    func testEmptyMissingAndSingleElement() {
        XCTAssertNil("".element(before: "a", wrapping: true))
        XCTAssertNil("abc".element(before: "z", wrapping: true))
        XCTAssertNil("a".element(before: "a"))
        XCTAssertEqual("a".element(before: "a", wrapping: true), "a")
        XCTAssertNil([Int]().element(before: 1, wrapping: true))
    }

    func testArraySliceWithNonzeroStartIndex() {
        let slice = [0, 10, 20, 30][1...3]
        XCTAssertNil(slice.element(before: 10))
        XCTAssertEqual(slice.element(before: 10, wrapping: true), 30)
        XCTAssertEqual(slice.element(before: 20), 10)
        XCTAssertNil(slice.element(before: 99, wrapping: true))
    }

    func testCaseIterablePreviousWraps() {
        XCTAssertEqual(StrictCase.first.previous(), .last)
        XCTAssertEqual(StrictCase.middle.previous(), .first)
        XCTAssertEqual(StrictCase.last.previous(), .middle)
        XCTAssertEqual(StrictCase.last.next(), .first)
    }

    func testSingleCaseWrapsToItself() {
        XCTAssertEqual(SingleCase.only.previous(), .only)
    }
}

private enum StrictCase: CaseIterable {
    case first, middle, last

    static var allCases: StrictCollection<StrictCase> {
        StrictCollection(elements: [.first, .middle, .last])
    }
}

private enum SingleCase: CaseIterable {
    case only
}

// Array에서 드러나지 않는 오류를 잡도록 startIndex 이전 이동을 금지한다.
private struct StrictCollection<Element>: BidirectionalCollection {
    let elements: [Element]
    var startIndex: Int { elements.startIndex }
    var endIndex: Int { elements.endIndex }
    subscript(index: Int) -> Element { elements[index] }

    func index(after index: Int) -> Int {
        precondition(index >= startIndex && index < endIndex)
        return index + 1
    }

    func index(before index: Int) -> Int {
        precondition(index > startIndex && index <= endIndex)
        return index - 1
    }
}
