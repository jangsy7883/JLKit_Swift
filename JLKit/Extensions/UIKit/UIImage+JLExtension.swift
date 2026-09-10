//
//  UIImage+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 4. 11..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
#if canImport(UIKit)
import UIKit

// MARK: - Create

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let image = UIImage.render(size: size, scale: 1) {
            if let context = UIGraphicsGetCurrentContext() {
                context.setFillColor(color.cgColor)
                context.fill(CGRect(origin: .zero, size: size))
            }
        }
        guard let cgImage = image?.cgImage else { return nil }

        self.init(cgImage: cgImage)
    }

    #if os(iOS)
    static func dynamicImage(withLight light: @autoclosure () -> UIImage?,
                             dark: @autoclosure () -> UIImage?) -> UIImage? {
        let lightTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .light)])
        let darkTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .dark)])
        
        var lightImage: UIImage?
        var darkImage: UIImage?

        lightTC.performAsCurrent {
            lightImage = light()
        }
        darkTC.performAsCurrent {
            darkImage = dark()
        }

        if let darkImage {
            lightImage?.imageAsset?.register(darkImage, with: UITraitCollection(userInterfaceStyle: .dark))
        }
        return lightImage
    }
    #endif
}

// MARK: - Resize / Crop

public extension UIImage {
    enum ResizeMode {
        case aspectFit
        case aspectFill

        func aspectRatio(to size: CGSize, original originalSize: CGSize) -> CGFloat {
            let aspectWidth = size.width / originalSize.width
            let aspectHeight = size.height / originalSize.height

            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }

    func resize(toMaxPixel pixel: CGFloat, scale: CGFloat = 1) -> UIImage {
        let hRatio = pixel / size.width
        let vRatio = pixel / size.height
        let ratio = min(hRatio, vRatio)
        return resize(ratio: ratio, scale: scale)
    }

    func resize(toMinPixel pixel: CGFloat, scale: CGFloat = 1) -> UIImage {
        let hRatio = pixel / size.width
        let vRatio = pixel / size.height
        let ratio = max(hRatio, vRatio)
        return resize(ratio: ratio, scale: scale)
    }

    func resize(_ targetSize: CGSize, resizeMode: ResizeMode = .aspectFill, scale: CGFloat = 1) -> UIImage {
        let ratio = resizeMode.aspectRatio(to: targetSize, original: size)
        return resize(ratio: ratio, scale: scale)
    }

    func resize(ratio: CGFloat, scale: CGFloat = 1) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: ceil(size.width * ratio), height: ceil(size.height * ratio))
        return resize(to: rect, scale: scale)
    }

    func resize(to rect: CGRect, scale: CGFloat = 1) -> UIImage {
        return UIImage.render(size: rect.size, scale: scale) {
            draw(in: rect)
        } ?? self
    }

    #if os(iOS)
    /// 표시용으로 미리 디코딩된 썸네일을 만듭니다. targetSize는 포인트 단위이며,
    /// scale을 생략하면 화면 스케일을 사용합니다.
    ///
    /// 디스크/네트워크에서 로드한 큰 이미지를 작게 표시할 때 resize보다 메모리 효율이 좋고,
    /// 반환된 이미지는 이미 디코딩되어 있어 렌더링 시점의 지연 디코딩이 없습니다.
    func thumbnail(fitting targetSize: CGSize,
                   resizeMode: ResizeMode = .aspectFill,
                   scale: CGFloat? = nil) async -> UIImage? {
        return await byPreparingThumbnail(ofSize: thumbnailPixelSize(fitting: targetSize, resizeMode: resizeMode, scale: scale))
    }

    /// 동기 버전 — 디코딩이 호출 스레드에서 일어나므로 백그라운드 스레드 사용을 권장합니다.
    func thumbnail(fitting targetSize: CGSize,
                   resizeMode: ResizeMode = .aspectFill,
                   scale: CGFloat? = nil) -> UIImage? {
        return preparingThumbnail(of: thumbnailPixelSize(fitting: targetSize, resizeMode: resizeMode, scale: scale))
    }

    private func thumbnailPixelSize(fitting targetSize: CGSize, resizeMode: ResizeMode, scale: CGFloat?) -> CGSize {
        let scale = scale ?? max(UITraitCollection.current.displayScale, 1)
        let ratio = resizeMode.aspectRatio(to: targetSize, original: size)
        return CGSize(width: size.width * ratio * scale,
                      height: size.height * ratio * scale)
    }
    #endif

    /// 표시 방향을 기준으로 포인트 단위 bounds를 잘라냅니다. 결과 방향은 .up입니다.
    func crop(bounds: CGRect) -> UIImage? {
        guard let cgImage else { return nil }

        let source: CGImage
        if imageOrientation == .up {
            source = cgImage
        } else {
            guard let normalized = UIImage.render(size: size, scale: scale, actions: {
                draw(in: CGRect(origin: .zero, size: size))
            })?.cgImage else { return nil }
            source = normalized
        }

        let pixelBounds = CGRect(x: bounds.origin.x * scale,
                                 y: bounds.origin.y * scale,
                                 width: bounds.width * scale,
                                 height: bounds.height * scale)
        guard let cropping = source.cropping(to: pixelBounds) else { return nil }

        return UIImage(cgImage: cropping, scale: scale, orientation: .up)
    }

    func cropToSquare() -> UIImage? {
        let shortest = min(size.width, size.height)
        let origin = CGPoint(x: (size.width - shortest) / 2, y: (size.height - shortest) / 2)
        return crop(bounds: CGRect(origin: origin, size: CGSize(width: shortest, height: shortest)))
    }

    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
        let size = CGSize(width: self.size.width + insets.left + insets.right, height: self.size.height + insets.top + insets.bottom)
        return UIImage.render(size: size, scale: scale) {
            draw(at: CGPoint(x: insets.left, y: insets.top))
        }
    }

    func withOrientation(_ orientation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = cgImage else { return nil }

        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation).withRenderingMode(renderingMode)
    }

    private static func render(size: CGSize, scale: CGFloat, actions: () -> Void) -> UIImage? {
        #if os(iOS)
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            actions()
        }
        #else
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        actions()
        return UIGraphicsGetImageFromCurrentImageContext()
        #endif
    }
}

// MARK: - Rendering Mode

public extension UIImage {
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }

    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - Data

public extension UIImage {
    enum ImageFormat {
        case JPEG(compressionQuality: CGFloat)
        case PNG
    }

    func data(_ format: ImageFormat) -> Data? {
        return autoreleasepool { () -> Data? in
            let data: Data?
            switch format {
            case .PNG: data = pngData()
            case let .JPEG(compressionQuality): data = jpegData(compressionQuality: compressionQuality)
            }
            return data
        }
    }

    func bytesSize(_ format: ImageFormat = .JPEG(compressionQuality: 1)) -> Int {
        return data(format)?.count ?? 0
    }

    func kilobytesSize(_ format: ImageFormat = .JPEG(compressionQuality: 1)) -> Int {
        return bytesSize(format) / 1024
    }
}

// MARK: - Color

#if canImport(CoreImage)
public extension UIImage {
    func averageColor() -> UIColor? {
        guard let ciImage = ciImage ?? CIImage(image: self) else { return nil }

        let parameters = [kCIInputImageKey: ciImage, kCIInputExtentKey: CIVector(cgRect: ciImage.extent)]
        guard let outputImage = CIFilter(name: "CIAreaAverage", parameters: parameters)?.outputImage else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let workingColorSpace: Any = cgImage?.colorSpace ?? NSNull()
        let context = CIContext(options: [.workingColorSpace: workingColorSpace])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        // Convert pixel data to UIColor
        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }
}
#endif

#endif
