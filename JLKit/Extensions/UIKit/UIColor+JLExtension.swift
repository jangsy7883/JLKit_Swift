//
//  UIColor+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 29/05/2019.
//  Copyright © 2019 Woody. All rights reserved.
//

#if canImport(UIKit)

import UIKit

#if canImport(CoreImage)
import CoreImage

public extension UIColor {
    // MARK: - RGBA Components (CoreImage)

    /// RGBA 컴포넌트를 한 번의 CIColor 생성으로 반환합니다.
    var rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let ci = CIColor(color: self)
        return (ci.red, ci.green, ci.blue, ci.alpha)
    }

    var redValue: CGFloat   { CIColor(color: self).red }
    var greenValue: CGFloat { CIColor(color: self).green }
    var blueValue: CGFloat  { CIColor(color: self).blue }
    var alphaValue: CGFloat { CIColor(color: self).alpha }
}

#endif


public extension UIColor {
    // MARK: - Hex

    enum JLHexFormat {
        case argb   // AARRGGBB
        case rgba   // RRGGBBAA
    }

    enum JLColorSpace {
        case sRGB
        case displayP3

        var colorSpace: CGColorSpace? {
            switch self {
            case .sRGB:      return CGColorSpace(name: CGColorSpace.sRGB)
            case .displayP3: return CGColorSpace(name: CGColorSpace.displayP3)
            }
        }
    }

    @nonobjc convenience init(hex: String, format: JLHexFormat = .argb, colorSpace: JLColorSpace = .displayP3) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8 where format == .rgba: // RGBA (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        switch colorSpace {
        case .sRGB:
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        case .displayP3:
            self.init(displayP3Red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }

    /// UIColor를 hex 문자열로 반환합니다.
    /// - Parameters:
    ///   - colorSpace: 변환에 사용할 색상 공간 (기본값: displayP3)
    ///   - format: alpha 포함 시 출력 포맷 (기본값: .argb → #AARRGGBB)
    func hex(_ colorSpace: JLColorSpace = .displayP3, format: JLHexFormat = .argb) -> String {
        guard let cgColorSpace = colorSpace.colorSpace,
              let cgColorInRGB = cgColor.converted(to: cgColorSpace, intent: .defaultIntent, options: nil) else {
            return "#000000"
        }
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColorInRGB.alpha

        let rgb = String(
            format: "%02lX%02lX%02lX",
            lround(Double(r * 255)),
            lround(Double(g * 255)),
            lround(Double(b * 255))
        )

        guard a < 1 else { return "#\(rgb)" }

        let alphaHex = String(format: "%02lX", lround(Double(a * 255)))
        switch format {
        case .rgba:
            return "#\(rgb)\(alphaHex)"
        case .argb:
            return "#\(alphaHex)\(rgb)"
        }
    }

    var hex: String { hex() }

    // MARK: - Random

    static var random: UIColor {
        random()
    }

    static func random(alpha: CGFloat = 1.0, colorSpace: JLColorSpace = .displayP3) -> UIColor {
        let r = CGFloat.random(in: 0...1)
        let g = CGFloat.random(in: 0...1)
        let b = CGFloat.random(in: 0...1)
        switch colorSpace {
        case .sRGB:
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        case .displayP3:
            return UIColor(displayP3Red: r, green: g, blue: b, alpha: alpha)
        }
    }

    // MARK: - Lighten / Darken

    func lighten(by percentage: CGFloat = 0.2) -> UIColor {
        if cgColor.colorSpace?.name == CGColorSpace.displayP3,
           let c = cgColor.components, c.count >= 3 {
            return UIColor(displayP3Red: min(c[0] + percentage, 1.0),
                           green:        min(c[1] + percentage, 1.0),
                           blue:         min(c[2] + percentage, 1.0),
                           alpha:        c.count >= 4 ? c[3] : cgColor.alpha)
        } else {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return UIColor(red: min(red + percentage, 1.0),
                           green: min(green + percentage, 1.0),
                           blue: min(blue + percentage, 1.0),
                           alpha: alpha)
        }
    }

    func darken(by percentage: CGFloat = 0.2) -> UIColor {
        if cgColor.colorSpace?.name == CGColorSpace.displayP3,
           let c = cgColor.components, c.count >= 3 {
            return UIColor(displayP3Red: max(c[0] - percentage, 0),
                           green:        max(c[1] - percentage, 0),
                           blue:         max(c[2] - percentage, 0),
                           alpha:        c.count >= 4 ? c[3] : cgColor.alpha)
        } else {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            return UIColor(red: max(red - percentage, 0),
                           green: max(green - percentage, 0),
                           blue: max(blue - percentage, 0),
                           alpha: alpha)
        }
    }

    // MARK: - Dynamic Color

    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        #if os(watchOS)
        return dark
        #else
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
        #endif
    }

    #if os(iOS)
    func resolvedColor(userInterfaceStyle: UIUserInterfaceStyle) -> UIColor {
        let traitCollection = UITraitCollection(userInterfaceStyle: userInterfaceStyle)
        return resolvedColor(with: traitCollection)
    }
    #endif

    var isDynamic: Bool {
        #if os(iOS)
        return self.resolvedColor(userInterfaceStyle: .light) != self.resolvedColor(userInterfaceStyle: .dark)
        #else
        return false
        #endif
    }
    
    // MARK: - Image
    
    func image(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        #if os(iOS)
        if isDynamic,
           let dark = UIImage(color: self.resolvedColor(userInterfaceStyle: .dark), size: size),
           let light = UIImage(color: self.resolvedColor(userInterfaceStyle: .light), size: size) {
            return UIImage.dynamicImage(withLight: light, dark: dark)
        } else {
            return UIImage(color: self, size: size)
        }
        #else
        return UIImage(color: self, size: size)
        #endif
    }
}

#endif
