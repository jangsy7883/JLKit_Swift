#if canImport(UIKit) && !os(watchOS)
import UIKit
import XCTest
import JLKit_Swift

final class TableIndexPathTests: XCTestCase {
    @MainActor
    func testNegativeAndOutOfBoundsIndicesAreInvalid() {
        let source = TableIndexSource(counts: [2])
        let table = makeTable(source)
        for row in [Int.min, -1, 2, Int.max] {
            XCTAssertFalse(table.isValidIndexPath(IndexPath(row: row, section: 0)))
        }
        for section in [Int.min, -1, 1, Int.max] {
            XCTAssertFalse(table.isValidIndexPath(IndexPath(row: 0, section: section)))
        }
    }

    @MainActor
    func testEmptyTableHasNoValidIndexPath() {
        let source = TableIndexSource(counts: [])
        let table = makeTable(source)
        XCTAssertFalse(table.isValidIndexPath(IndexPath(row: 0, section: 0)))
        XCTAssertFalse(table.isValidIndexPath(IndexPath(row: -1, section: -1)))
    }

    @MainActor
    func testRowsAreCheckedAgainstTheirOwnSection() {
        let source = TableIndexSource(counts: [2, 0, 1])
        let table = makeTable(source)
        XCTAssertTrue(table.isValidIndexPath(IndexPath(row: 0, section: 0)))
        XCTAssertTrue(table.isValidIndexPath(IndexPath(row: 1, section: 0)))
        XCTAssertFalse(table.isValidIndexPath(IndexPath(row: 0, section: 1)))
        XCTAssertTrue(table.isValidIndexPath(IndexPath(row: 0, section: 2)))
        XCTAssertFalse(table.isValidIndexPath(IndexPath(row: 1, section: 2)))
    }

    @MainActor
    private func makeTable(_ source: TableIndexSource) -> UITableView {
        let table = UITableView()
        table.dataSource = source
        table.reloadData()
        return table
    }
}

@MainActor
private final class TableIndexSource: NSObject, UITableViewDataSource {
    let counts: [Int]
    init(counts: [Int]) { self.counts = counts }
    func numberOfSections(in tableView: UITableView) -> Int { counts.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { counts[section] }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}
#endif
