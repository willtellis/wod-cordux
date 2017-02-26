//
//  IntRouteConvertible.swift
//  WODCordux
//
//  Created by Will Ellis on 2/25/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

extension Int: RouteConvertible {
    public func route() -> Route {
        return Cordux.Route(String(describing: self))
    }
}
