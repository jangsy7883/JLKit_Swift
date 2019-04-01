//
//  UIView+JLExtension.swift
//  JLKit_Swift
//
//  Created by Jangsy on 2018. 1. 18..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension NSString {
    public static func nameFormClass(_ class_: Any) -> String? {
        let name = String(describing: class_.self)
        let words = name.components(separatedBy: ".")
        
        return words.last
    }
}

extension String {
    public var boolValue: Bool {
        get {
            return NSString(string: self).boolValue
        }
    }
    
    public var trimmedString: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public var image: UIImage? {
        return UIImage(named: self)
    }

    public func localized(tableName: String? = nil, bundle : Bundle = Bundle.main, comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: self, comment: comment)
    }
    
    //MARK :
    
    func base64Data(options:Data.Base64DecodingOptions = .ignoreUnknownCharacters) -> Data? {
        return Data(base64Encoded: self, options: options)
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
}

