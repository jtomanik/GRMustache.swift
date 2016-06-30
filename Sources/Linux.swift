//
//  Linux.swift
//  Mustache
//
//  Created by Jakub Tomanik on 30/06/16.
//
//

import Foundation

#if os(Linux)

    extension NSFormatter {

        public func string(for obj: NSObject) {
            return self.stringForObjectValue(obj)
        }
    }

#endif
