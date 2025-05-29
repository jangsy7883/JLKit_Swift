//
//  NSAttributedString+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
    var isEmpty: Bool {
        return string.isEmpty
    }
    
    /// 첫 번째 문자에 적용된 attributes만 반환함을 명시적으로 알림
    var firstAttributes: [Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }
    
    /// 전체 문자열의 attributes를 구간별로 반환
    var allAttributes: [(attributes: [Key: Any], range: NSRange)] {
        var result: [(attributes: [Key: Any], range: NSRange)] = []
        var idx = 0
        while idx < length {
            var range = NSRange(location: 0, length: 0)
            let attrs = attributes(at: idx, effectiveRange: &range)
            result.append((attrs, range))
            idx = range.location + range.length
        }
        return result
    }
}

public extension NSAttributedString {
    func font(_ font: UIFont) -> NSAttributedString {
        applying(attributes: [.font: font])
    }
    
    func color(_ color: UIColor) -> NSAttributedString {
        applying(attributes: [.foregroundColor: color])
    }

    func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        // 항상 복사본(NSMutableParagraphStyle) 사용
        let mutableParagraph = (paragraphStyle as? NSMutableParagraphStyle) ?? paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
        return applying(attributes: [.paragraphStyle: mutableParagraph])
    }
    
    func lineBreakStrategy(_ lineBreakStrategy: NSParagraphStyle.LineBreakStrategy) -> NSAttributedString {
        let baseStyle = (firstAttributes[.paragraphStyle] as? NSParagraphStyle) ?? NSParagraphStyle.default
        let paragraphStyle = (baseStyle.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakStrategy = lineBreakStrategy
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSAttributedString {
        let baseStyle = (firstAttributes[.paragraphStyle] as? NSParagraphStyle) ?? NSParagraphStyle.default
        let paragraphStyle = (baseStyle.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    func alignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let baseStyle = (firstAttributes[.paragraphStyle] as? NSParagraphStyle) ?? NSParagraphStyle.default
        let paragraphStyle = (baseStyle.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    /// 전체 범위에 적용, 부분 범위는 range 파라미터 사용
    func applying(attributes: [Key: Any], range: NSRange? = nil) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let targetRange = range ?? NSRange(location: 0, length: length)
        copy.addAttributes(attributes, range: targetRange)
        return copy
    }
}

public extension NSMutableAttributedString {
    func addAttributes(_ attrs: [NSAttributedString.Key: Any], text: String) {
        let ranges = string.ranges(of: text)
        for range in ranges {
            let nsRange = NSRange(range, in: string)
            addAttributes(attrs, range: nsRange)
        }
    }
    
    func appendString(_ text: String, attributes: [NSAttributedString.Key: Any]) {
        guard text.isEmpty == false, attributes.isEmpty == false else { return }
        append(NSAttributedString(string: text, attributes: attributes))
    }
}

// MARK: - String Extension for Ranges
public extension String {
    /// 문자열 내 모든 서브스트링의 범위를 반환
    func ranges(of searchString: String) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        var startIdx = startIndex
        while startIdx < endIndex,
              let range = self.range(of: searchString, range: startIdx..<endIndex) {
            ranges.append(range)
            startIdx = range.upperBound
        }
        return ranges
    }
}

public typealias AttributedKeyValues = [NSAttributedString.Key: Any]

public extension AttributedKeyValues {
    func color(_ color: UIColor) -> AttributedKeyValues {
        var attributes = self
        attributes[.foregroundColor] = color
        return attributes
    }
    
    func font(_ font: UIFont) -> AttributedKeyValues {
        var attributes = self
        attributes[.font] = font
        return attributes
    }
    
    func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> AttributedKeyValues {
        var attributes = self
        attributes[.paragraphStyle] = paragraphStyle
        return attributes
    }
}
