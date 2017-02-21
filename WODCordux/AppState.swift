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
}

struct WodState {
    var name: String
    var content: String
}

final class AppReducer: Reducer {
    
    func handleAction(_ action: Action, state: AppState) -> AppState {
        // TODO: WTE - let state = reduceSomething(action, state: state)
        return state
    }
}
