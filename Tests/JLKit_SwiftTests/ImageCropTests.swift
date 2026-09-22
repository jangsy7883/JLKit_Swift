#if canImport(UIKit) && os(iOS)
import UIKit
import XCTest
import JLKit_Swift

final class ImageCropTests: XCTestCase {
    private let orientations: [UIImage.Orientation] = [
        .up, .down, .left, .right, .upMirrored, .downMirrored, .leftMirrored, .rightMirrored
    ]

    func testCropMatchesDisplayedRegionForEveryOrientationAndScale() throws {
        for scale: CGFloat in [1, 2, 3] {
            let base = fixture(scale: scale)
            for orientation in orientations {
                let image = UIImage(cgImage: try XCTUnwrap(base.cgImage), scale: scale, orientation: orientation)
                let bounds = CGRect(x: 1, y: 1, width: 2, height: 1)
                let cropped = try XCTUnwrap(image.crop(bounds: bounds))
                // 요청 영역 크기의 캔버스에 원본을 이동해서 그린 결과와 비교한다.
                let expected = render(size: bounds.size, scale: scale) {
                    image.draw(at: CGPoint(x: -bounds.minX, y: -bounds.minY))
                }
                XCTAssertEqual(cropped.size, bounds.size)
                XCTAssertEqual(cropped.scale, scale)
                XCTAssertEqual(cropped.imageOrientation, .up)
                XCTAssertEqual(try pixels(cropped), try pixels(expected), "orientation: \(orientation), scale: \(scale)")
            }
        }
    }

    func testSquareCropIsCenteredForEveryOrientation() throws {
        let base = fixture(scale: 2)
        for orientation in orientations {
            let image = UIImage(cgImage: try XCTUnwrap(base.cgImage), scale: 2, orientation: orientation)
            let side = min(image.size.width, image.size.height)
            let cropped = try XCTUnwrap(image.cropToSquare())
            let expected = render(size: CGSize(width: side, height: side), scale: 2) {
                image.draw(at: CGPoint(x: -(image.size.width - side) / 2,
                                       y: -(image.size.height - side) / 2))
            }
            XCTAssertEqual(cropped.size, CGSize(width: side, height: side))
            XCTAssertEqual(try pixels(cropped), try pixels(expected), "orientation: \(orientation)")
        }
    }

    func testOutOfBoundsCropRemainsClippedOrNil() throws {
        let base = fixture(scale: 2)
        for orientation in orientations {
            let image = UIImage(cgImage: try XCTUnwrap(base.cgImage), scale: 2, orientation: orientation)
            XCTAssertNil(image.crop(bounds: CGRect(x: 100, y: 100, width: 1, height: 1)))
            let cropped = try XCTUnwrap(image.crop(bounds: CGRect(x: -1, y: -1, width: 2, height: 2)))
            XCTAssertEqual(cropped.size, CGSize(width: 1, height: 1))
        }
    }

    private func fixture(scale: CGFloat) -> UIImage {
        render(size: CGSize(width: 6, height: 4), scale: scale) {
            for y in 0..<4 {
                for x in 0..<6 {
                    UIColor(red: CGFloat(x) / 5, green: CGFloat(y) / 3,
                            blue: CGFloat((x + y) % 2), alpha: 1).setFill()
                    UIRectFill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }
        }
    }

    private func render(size: CGSize, scale: CGFloat, drawing: () -> Void) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.preferredRange = .standard
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in drawing() }
    }

    private func pixels(_ image: UIImage) throws -> [UInt8] {
        let cgImage = try XCTUnwrap(image.cgImage)
        var bytes = [UInt8](repeating: 0, count: cgImage.width * cgImage.height * 4)
        try bytes.withUnsafeMutableBytes { buffer in
            let context = try XCTUnwrap(CGContext(
                data: buffer.baseAddress, width: cgImage.width, height: cgImage.height,
                bitsPerComponent: 8, bytesPerRow: cgImage.width * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ))
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        }
        return bytes
    }
}
#endif
