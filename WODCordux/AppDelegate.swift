//
//  AppDelegate.swift
//  WODCordux
//
//  Created by Will Ellis on 2/15/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import UIKit
import Cordux

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let mainController = window?.rootViewController as? MainViewController else {
            fatalError()
        }
        
        UIViewController.swizzleLifecycleDelegatingViewControllerMethods()
        
        var state = AppState()
        state.route = AppCoordinator.RouteSegment.wods.route()
        let store = Store(initialState: state, reducer: AppReducer(), middlewares: [/*ActionLogger()*/])
        
        coordinator = AppCoordinator(store: store, container: mainController)
        coordinator.start(route: state.route)
        
        return true
    }

}

