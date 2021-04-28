//
//  UIView+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 1. 18..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//
import UIKit
import Foundation

extension NSString {
    public static func nameFormClass(_ class_: Any) -> String? {
        let name = String(describing: class_.self)
        let words = name.components(separatedBy: ".")
        
        return words.last
    }
}

extension String {
    public var trimmedString: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func localized(tableName: String? = nil, bundle : Bundle = Bundle.main, comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: comment)
    }
    
    public static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    //MARK : - Range
    
    public func regexMatches(pattern: String) -> [NSTextCheckingResult]? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let matches = regex?.matches(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
            return matches
        }
        return nil
    }
    
    public func rangeOfFirstRegexMatch(pattern: String) -> NSRange? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        if let range = regex?.rangeOfFirstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
            return range
        }
        return nil
    }
    
    public func isRegexMatch(pattern: String) -> Bool {
        if let length = rangeOfFirstRegexMatch(pattern: pattern)?.length, length > 0 {
            return true
        }
        return false
    }
    
    public func nsRange(of text: String) -> NSRange? {
        guard let range = range(of: text),
            let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16) else { return nil }        
        
        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
                         length: utf16.distance(from: from, to: to))
    }
    
    //MARK : - Convert

    public var boolValue: Bool {
        return ["true", "y", "t", "yes", "1"].contains { self.caseInsensitiveCompare($0) == .orderedSame }
    }

    public var int: Int? {
        return Int(self)
    }

    public var url: URL? {
        return URL(string: self)
    }

    public var intValue: Int {
        return int ?? 0
    }

    public var color : UIColor { return UIColor(hex: self) }
    
    public var image: UIImage? { return UIImage(named: self) }
    
    public func attributedString(attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    public func base64Data(options:Data.Base64DecodingOptions = .ignoreUnknownCharacters) -> Data? {
        return Data(base64Encoded: self, options: options)
    }
}


extension String {

    #if os(iOS)
    public func boundingSize(maxSize: CGSize, font: UIFont) -> CGSize {
        return self.boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: [.font: font], context: nil).size
    }
    #endif

}
