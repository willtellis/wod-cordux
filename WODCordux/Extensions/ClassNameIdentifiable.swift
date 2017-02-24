//
//  ClassNameIdentifiable.swift
//  WODCordux
//
//  Created by Will Ellis on 2/23/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import UIKit

public protocol ClassNameIdentifiable {
    static var reusableIdentifier: String { get }
}

extension ClassNameIdentifiable where Self: UITableViewCell {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
