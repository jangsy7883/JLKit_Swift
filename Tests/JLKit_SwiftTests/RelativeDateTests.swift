import Foundation
import XCTest
import JLKit_Swift

final class RelativeDateTests: XCTestCase {
    private func expected(_ date: Date, relativeTo reference: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: reference)
    }

    func testSameHistoricalDateUsesSuppliedReference() {
        let date = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(date.toLocalizedRelative(to: date), expected(date, relativeTo: date))
    }

    func testPastAndFutureReferences() {
        let date = Date(timeIntervalSince1970: 0)
        let earlier = date.addingTimeInterval(-7 * 24 * 60 * 60)
        let later = date.addingTimeInterval(7 * 24 * 60 * 60)

        XCTAssertEqual(date.toLocalizedRelative(to: earlier), expected(date, relativeTo: earlier))
        XCTAssertEqual(date.toLocalizedRelative(to: later), expected(date, relativeTo: later))
        XCTAssertNotEqual(date.toLocalizedRelative(to: earlier), date.toLocalizedRelative(to: later))
    }
}
