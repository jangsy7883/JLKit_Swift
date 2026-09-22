import Foundation
import XCTest
import JLKit_Swift

final class DictionaryLookupTests: XCTestCase {
    func testIncompletePathsReturnNil() {
        let values: [String: Any] = ["a": 1, "nested": ["b": 2]]
        XCTAssertNil(values[keyPath: "a.b"])
        XCTAssertNil(values[keyPath: "nested.b.c"])
        XCTAssertNil(values[keyPath: "nested.missing"])
        XCTAssertNil(values[keyPath: "missing"])
        XCTAssertNil([String: Any]()[keyPath: "a"])
    }

    func testCompletePathsReturnLeafAndDictionaryValues() {
        let values: [String: Any] = ["a": ["b": ["c": 3]], "zero": 0]
        XCTAssertEqual(values[keyPath: "a.b.c"] as? Int, 3)
        XCTAssertEqual(values[keyPath: "a.b"] as? [String: Int], ["c": 3])
        XCTAssertEqual(values[keyPath: "zero"] as? Int, 0)
    }

    func testStringCandidatesKeepPathSemanticsAndOrder() {
        let values: [String: Any] = ["a": 1, "nested": ["b": 2], "nested.b": 99]
        XCTAssertEqual(values.valueForKeys(["a.invalid", "nested.b", "a"]) as? Int, 2)
        XCTAssertEqual(values.valueForKeys(["a", "nested.b"]) as? Int, 1)
        XCTAssertNil(values.valueForKeys(["a.invalid", "missing"]))
        XCTAssertNil(values.valueForKeys([]))
    }

    func testNonStringKeysAreLookedUpDirectly() {
        let values = [1: "one", 2: "two"]
        XCTAssertEqual(values.valueForKeys([9, 2, 1]) as? String, "two")
        XCTAssertNil(values.valueForKeys([9]))

        let id = UUID()
        XCTAssertEqual([id: 42].valueForKeys([id]) as? Int, 42)
    }

    func testAnyHashableKeysSupportPathsAndDirectKeys() {
        let values: [AnyHashable: Any] = ["a": ["b": 2], 7: "seven"]
        XCTAssertEqual(values.valueForKeys(["a.b", 7]) as? Int, 2)
        XCTAssertEqual(values.valueForKeys(["a.missing", 7]) as? String, "seven")
    }
}
