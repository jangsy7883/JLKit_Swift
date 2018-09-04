//
//  Loggable.swift
//  Goodoc
//
//  Created by Jangsy on 2018. 3. 15..
//  Copyright © 2018년 Dalkomm. All rights reserved.
//

import Foundation

protocol Loggable { }

extension Loggable {

}

func debugLog<T>( _ object: @autoclosure() -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        let stringRepresentation: String
        
        if let value = value as? String {
            stringRepresentation = value
        }
        else if let value = value as? CustomDebugStringConvertible {
            stringRepresentation = value.debugDescription
        }
        else if let value = value as? CustomStringConvertible {
            stringRepresentation = value.description
        }
        else {
            fatalError("gLog only works for values that conform to CustomDebugStringConvertible or CustomStringConvertible")
        }

        let fileURL = NSURL(string: file)?.deletingPathExtension?.lastPathComponent ?? "Unknown file"
        let queue = Thread.isMainThread ? "M" : "B"//Thread.current.name ?? "UNKNOWN"
//        let gFormatter = DateFormatter()
//        gFormatter.dateFormat = "HH:mm:ss:SSS"
//        let timestamp = gFormatter.string(from: Date())
        
        print("[\(fileURL) \(function)] \(queue) (line \(line)) " + stringRepresentation)
    #endif
}
