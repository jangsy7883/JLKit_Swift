//
//  NSAttributedString+JLExtension.swift
//  JLKit_Swift
//
//  Created by jangsy on 2018. 5. 23..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func addAttributes(_ attrs:[NSAttributedStringKey:Any], text:String) {
        if let range = string.range(of: text) {
            let startPos = string.distance(from: string.startIndex, to: range.lowerBound)
            
            addAttributes(attrs, range: NSMakeRange(startPos, text.count))
        }
    }
    
    func appendString(_ text:String, attributes:[NSAttributedStringKey:Any]) {
        guard text.isEmpty == false, attributes.isEmpty == false else { return }
        append(NSAttributedString(string: text, attributes: attributes))
    }
}
