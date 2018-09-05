//
//  UIView+JLExtension.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 1. 18..
//  Copyright © 2018년 Goodoc. All rights reserved.
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

    public func localized(tableName: String? = nil, comment: String = "") -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    //
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

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
extension String {
    var md5: String { return digest(string: self, algorithm: .MD5) }
    var sha1: String { return digest(string: self, algorithm: .SHA1) }
    var sha224: String { return digest(string: self, algorithm: .SHA224) }
    var sha256: String { return digest(string: self, algorithm: .SHA256) }
    var sha384: String { return digest(string: self, algorithm: .SHA384) }
    var sha512: String { return digest(string: self, algorithm: .SHA512) }
    
    func digest(string: String, algorithm: CryptoAlgorithm) -> String {
        var result: [CUnsignedChar]
        let digestLength = Int(algorithm.digestLength)
        if let cdata = string.cString(using: String.Encoding.utf8) {
            result = Array(repeating: 0, count: digestLength)
            switch algorithm {
            case .MD5:      CC_MD5(cdata, CC_LONG(cdata.count-1), &result)
            case .SHA1:     CC_SHA1(cdata, CC_LONG(cdata.count-1), &result)
            case .SHA224:   CC_SHA224(cdata, CC_LONG(cdata.count-1), &result)
            case .SHA256:   CC_SHA256(cdata, CC_LONG(cdata.count-1), &result)
            case .SHA384:   CC_SHA384(cdata, CC_LONG(cdata.count-1), &result)
            case .SHA512:   CC_SHA512(cdata, CC_LONG(cdata.count-1), &result)
            }
        } else {
            fatalError("Nil returned when processing input strings as UTF8")
        }
        return (0..<digestLength).reduce("") { $0 + String(format: "%02hhx", result[$1])}
    }
}
