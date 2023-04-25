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
    
    var attributes: [Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }
}

public extension NSAttributedString {
    func font(_ font: UIFont) -> NSAttributedString {
        applying(attributes: [.font: font])
    }
    
    func color(_ color: UIColor) -> NSAttributedString {
        applying(attributes: [.foregroundColor: color])
    }

    func paragraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> NSAttributedString {
        applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    func lineBreakStrategy(_ lineBreakStrategy: NSParagraphStyle.LineBreakStrategy) -> NSAttributedString {
        let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakStrategy = lineBreakStrategy
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSAttributedString {
        let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    
    func alignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = attributes(at: 0, effectiveRange: nil)[.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }

    
    func applying(attributes: [Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        copy.addAttributes(attributes, range: NSRange(0..<length))
        return copy
    }
}

public extension NSMutableAttributedString {
    @objc func addAttributes(_ attrs: [NSAttributedString.Key: Any], text: String) {
        guard let range = string.nsRange(of: text) else { return }        
        addAttributes(attrs, range: range)
    }
    
    @objc func appendString(_ text:String, attributes:[NSAttributedString.Key:Any]) {
        guard text.isEmpty == false, attributes.isEmpty == false else { return }
        append(NSAttributedString(string: text, attributes: attributes))
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

