#if canImport(UIKit) && !os(watchOS)
import UIKit
import XCTest
import JLKit_Swift

final class CollectionLastItemTests: XCTestCase {
    @MainActor
    func testNoSectionsReturnsNil() {
        let source = LastItemSource(counts: [])
        let collection = makeCollection(source)
        XCTAssertNil(collection.indexPathForLastItem)
        XCTAssertNil(collection.indexPathForLastItem(inSection: 0))
    }

    @MainActor
    func testEmptySectionReturnsNil() {
        let source = LastItemSource(counts: [0])
        let collection = makeCollection(source)
        XCTAssertNil(collection.indexPathForLastItem)
        XCTAssertNil(collection.indexPathForLastItem(inSection: 0))
    }

    @MainActor
    func testPopulatedAndTrailingEmptySections() {
        let source = LastItemSource(counts: [1, 3, 0])
        let collection = makeCollection(source)
        XCTAssertEqual(collection.indexPathForLastItem(inSection: 0), IndexPath(item: 0, section: 0))
        XCTAssertEqual(collection.indexPathForLastItem(inSection: 1), IndexPath(item: 2, section: 1))
        XCTAssertNil(collection.indexPathForLastItem(inSection: 2))
        XCTAssertNil(collection.indexPathForLastItem)
    }

    @MainActor
    func testLastItemPropertyAndInvalidSections() {
        let source = LastItemSource(counts: [0, 2])
        let collection = makeCollection(source)
        XCTAssertEqual(collection.indexPathForLastItem, IndexPath(item: 1, section: 1))
        for section in [Int.min, -1, 2, Int.max] {
            XCTAssertNil(collection.indexPathForLastItem(inSection: section))
        }
    }

    @MainActor
    private func makeCollection(_ source: LastItemSource) -> UICollectionView {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.dataSource = source
        collection.reloadData()
        return collection
    }
}

@MainActor
private final class LastItemSource: NSObject, UICollectionViewDataSource {
    let counts: [Int]
    init(counts: [Int]) { self.counts = counts }
    func numberOfSections(in collectionView: UICollectionView) -> Int { counts.count }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        counts[section]
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    }
}
#endif
