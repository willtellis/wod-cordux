//
//  CollectionExtensions.swift
//  WODCordux
//
//  Created by Will Ellis on 2/25/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return (startIndex..<endIndex).contains(index) ? self[index] : nil
    }
}
