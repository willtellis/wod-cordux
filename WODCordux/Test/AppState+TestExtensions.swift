//
//  AppState+TestExtensions.swift
//  WODCordux
//
//  Created by Will Ellis on 2/22/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation

extension AppState {
    static let test: AppState = {
        let browsingState = BrowsingState(
            wods: [WodState(name: "Endurence Warmup", content: "3 rounds of 1:00 each samson stretch, air squat, ring row, push up, good morning, sit up")]
        )
        return AppState(
            route: AppCoordinator.RouteSegment.wods.route(),
            initialization: .initialized(browsingState)
        )
    }()
}
