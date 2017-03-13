//
//  AppState.swift
//  WODCordux
//
//  Created by Will Ellis on 2/16/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

typealias Store = Cordux.Store<AppState>

struct AppState: StateType {
    var route: Route = []
    var initialization: Initialization = .uninitialized
}

enum Initialization {
    case uninitialized
    case initialized(BrowsingState)
}

struct BrowsingState {
    var wods: [WodState] = []
    var newWod: WodState? = nil
}

struct WodState {
    var name: String
    var content: String
}

enum WodAction {
    case create(WodState)
}

final class AppReducer: Reducer {
    
    func handleAction(_ action: Action, state: AppState) -> AppState {
        switch action  {
        case let action as RouteAction<WodDetailsCoordinator.RouteSegment>:
            return reduceRouteActionWodDetails(action, state: state)
        default:
            return state
        }
    }

    func reduceRouteActionWodDetails(_ action: RouteAction<WodDetailsCoordinator.RouteSegment>, state: AppState) -> AppState {
        guard case .initialized(let browsingState) = state.initialization else {
            return state
        }

        switch action {
        case .push(let routeSegment):
            switch routeSegment {
            case .new:
                var newBrowsingState = browsingState
                newBrowsingState.newWod = WodState(name: "New", content: "New content")
                return AppState(route: state.route, initialization: .initialized(newBrowsingState))
            case .existing:
                return state
            }
        case .goto, .pop, .replace:
            return state
        }
    }

}
