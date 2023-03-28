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
        return applying(attributes: [.font: font])
    }
    
    func color(_ color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }

    func paragraphStyle(_ paragraphStyle: NSMutableParagraphStyle) -> NSAttributedString {
        return applying(attributes: [.paragraphStyle: paragraphStyle])
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

