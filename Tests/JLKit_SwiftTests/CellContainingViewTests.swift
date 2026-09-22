#if canImport(UIKit) && !os(watchOS)
import UIKit
import XCTest
import JLKit_Swift

final class CellContainingViewTests: XCTestCase {
    @MainActor
    func testTableLookupWithoutCellReturnsNil() {
        let table = UITableView()
        let root = UIView()
        let child = UIView()
        root.addSubview(child)

        XCTAssertNil(table.indexPath(forCellContainingView: nil))
        XCTAssertNil(table.indexPath(forCellContainingView: root))
        XCTAssertNil(table.indexPath(forCellContainingView: child))
        XCTAssertNil(table.indexPath(forCellContainingView: table))
        XCTAssertNil(table.indexPath(forCellContainingView: UITableViewCell()))
    }

    @MainActor
    func testCollectionLookupWithoutCellReturnsNil() {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let root = UIView()
        let child = UIView()
        root.addSubview(child)

        XCTAssertNil(collection.indexPath(forCellContainingView: nil))
        XCTAssertNil(collection.indexPath(forCellContainingView: root))
        XCTAssertNil(collection.indexPath(forCellContainingView: child))
        XCTAssertNil(collection.indexPath(forCellContainingView: collection))
        XCTAssertNil(collection.indexPath(forCellContainingView: UICollectionViewCell()))
    }

    @MainActor
    func testTableLookupFindsCellAndNestedSubview() {
        let source = TableSource()
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        table.dataSource = source
        table.reloadData()
        table.layoutIfNeeded()
        let expected = IndexPath(row: 0, section: 0)
        guard let cell = table.cellForRow(at: expected) else {
            return XCTFail("표시된 테스트 셀이 필요합니다.")
        }
        let container = UIView()
        let child = UIView()
        cell.contentView.addSubview(container)
        container.addSubview(child)

        XCTAssertEqual(table.indexPath(forCellContainingView: cell), expected)
        XCTAssertEqual(table.indexPath(forCellContainingView: child), expected)
        XCTAssertNil(UITableView().indexPath(forCellContainingView: child))
    }

    @MainActor
    func testCollectionLookupFindsCellAndNestedSubview() {
        let source = CollectionSource()
        let collection = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: 320, height: 480),
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.dataSource = source
        collection.reloadData()
        collection.layoutIfNeeded()
        let expected = IndexPath(item: 0, section: 0)
        guard let cell = collection.cellForItem(at: expected) else {
            return XCTFail("표시된 테스트 셀이 필요합니다.")
        }
        let container = UIView()
        let child = UIView()
        cell.contentView.addSubview(container)
        container.addSubview(child)

        XCTAssertEqual(collection.indexPath(forCellContainingView: cell), expected)
        XCTAssertEqual(collection.indexPath(forCellContainingView: child), expected)
        let other = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        XCTAssertNil(other.indexPath(forCellContainingView: child))
    }
}

@MainActor
private final class TableSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}

@MainActor
private final class CollectionSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 1 }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}
#endif
