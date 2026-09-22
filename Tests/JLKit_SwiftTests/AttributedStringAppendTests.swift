import Foundation
import XCTest
import JLKit_Swift

final class AttributedStringAppendTests: XCTestCase {
    private let key = NSAttributedString.Key("JLKitTests.marker")

    func testEmptyAttributesAppendPlainText() {
        let value = NSMutableAttributedString(string: "")
        value.appendString("안녕 👋", attributes: [:])
        XCTAssertEqual(value.string, "안녕 👋")
        XCTAssertTrue(value.attributes(at: 0, effectiveRange: nil).isEmpty)
    }

    func testPlainTextDoesNotInheritExistingAttributes() {
        let value = NSMutableAttributedString(string: "A", attributes: [key: "existing"])
        value.appendString("B", attributes: [:])
        XCTAssertEqual(value.string, "AB")
        XCTAssertEqual(value.attribute(key, at: 0, effectiveRange: nil) as? String, "existing")
        XCTAssertTrue(value.attributes(at: 1, effectiveRange: nil).isEmpty)
    }

    func testSuppliedAttributesApplyOnlyToAppendedText() {
        let value = NSMutableAttributedString(string: "A", attributes: [key: "existing"])
        value.appendString("BC", attributes: [key: "appended"])
        XCTAssertEqual(value.string, "ABC")
        XCTAssertEqual(value.attribute(key, at: 0, effectiveRange: nil) as? String, "existing")
        XCTAssertEqual(value.attribute(key, at: 1, effectiveRange: nil) as? String, "appended")
        XCTAssertEqual(value.attribute(key, at: 2, effectiveRange: nil) as? String, "appended")
    }

    func testEmptyTextLeavesContentAndAttributesUnchanged() {
        let value = NSMutableAttributedString(string: "A", attributes: [key: "existing"])
        let original = NSAttributedString(attributedString: value)
        value.appendString("", attributes: [:])
        value.appendString("", attributes: [key: "new"])
        XCTAssertTrue(value.isEqual(to: original))
    }
}
