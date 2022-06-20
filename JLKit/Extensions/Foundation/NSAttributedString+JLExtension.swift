//
//  NSAttributedString+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    var isEmpty: Bool {
        return string.isEmpty
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
