//
//  UIColor+JLExtension.swift
//  JLKit_Swift
//
//  Created by 장석용 on 29/05/2019.
//  Copyright © 2019 Woody. All rights reserved.
//

#if canImport(CoreImage)
import CoreImage

public extension UIColor {
    var redValue: CGFloat { return CIColor(color: self).red }
    var greenValue: CGFloat { return CIColor(color: self).green }
    var blueValue: CGFloat { return CIColor(color: self).blue }
    var alphaValue: CGFloat { return CIColor(color: self).alpha }
}

#endif
#if canImport(UIKit)

import UIKit

public extension UIColor {
    //MARK: - Hex
    enum JLHexFormat {
        case argb   // AARRGGBB
        case rgba   // RRGGBBAA
        case auto
    }

    enum JLColorSpace {
        case sRGB
        case displayP3
         
        var colorSpace: CGColorSpace {
            switch self {
            case .sRGB:         return CGColorSpace(name: CGColorSpace.sRGB)!
            case .displayP3:    return CGColorSpace(name: CGColorSpace.displayP3)!
            }
        }
    }
    
    @nonobjc convenience init(hex: String, format: JLHexFormat = .auto, colorSpace:JLColorSpace = .displayP3) {
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
    
    func hex(_ colorSpace: JLColorSpace = .displayP3) -> String {
        let cgColorInRGB = cgColor.converted(to: colorSpace.colorSpace, intent: .defaultIntent, options: nil)!
        let colorRef = cgColorInRGB.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha

        let color = String(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )

        if a < 1 {
            return "#\(String(format: "%02lX", lroundf(Float(a * 255))))\(color)"
        } else {
            return "#\(color)"
        }
    }
    
    var hex: String {
        hex(.displayP3)
    }
}


public extension UIColor {
    static var random: UIColor {
        UIColor.random()
    }
    
    static func random(alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1),
                       green: CGFloat.random(in: 0...1),
                       blue: CGFloat.random(in: 0...1),
                       alpha: 1.0)
    }
}

public extension UIColor {
    func lighten(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: min(red + percentage, 1.0),
                       green: min(green + percentage, 1.0),
                       blue: min(blue + percentage, 1.0),
                       alpha: alpha)
    }
    
    func darken(by percentage: CGFloat = 0.2) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: max(red - percentage, 0),
                       green: max(green - percentage, 0),
                       blue: max(blue - percentage, 0),
                       alpha: alpha)
    }
}

public extension UIColor {
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
    
    func image(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        #if os(iOS)
        if isDynamic,
           let dark = UIImage(color: self.resolvedColor(userInterfaceStyle: .dark)),
           let light = UIImage(color: self.resolvedColor(userInterfaceStyle: .light)) {
            return UIImage.dynamicImage(withLight: light, dark: dark)
        }else {
            return UIImage(color: self, size:size)
        }
        #else
        return UIImage(color: self, size:size)
        #endif
    }
    

    var isDynamic: Bool {
        #if os(iOS)
        return self.resolvedColor(userInterfaceStyle: .light) != self.resolvedColor(userInterfaceStyle: .dark)
        #else
        return false
        #endif
    }
}

#endif
