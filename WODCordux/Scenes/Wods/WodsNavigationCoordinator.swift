//
//  WodsNavigationCoordinator.swift
//  WODCordux
//
//  Created by Will Ellis on 2/26/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

// TODO: WTE - Define this better. Should it be a UUID and/or part of the WodState?
typealias WodRouteId = Int

final class WodsNavigationCoordinator: NavigationControllerMetaCoordinator {
    
    var store: Store
    var navigationController: UINavigationController = UINavigationController()
    var coordinators: [AnyCoordinator] = []
    
    init(store: Store) {
        self.store = store
        
    }
        
    func coordinators(for route: Route) -> [AnyCoordinator] {
        var coordinators: [AnyCoordinator] = []
        var routeTail = route
        
        if let segment = routeTail.first, segment.route() == WodsCoordinator.RouteSegment.list.route() {
            coordinators.append(WodsCoordinator(store: store))
            routeTail = Route(routeTail.dropFirst())
        }

        if let (routeSegment, trimmedRoute) = WodDetailsCoordinator.RouteSegment.trim(fromRoute: routeTail) {
            routeTail = trimmedRoute
            let mode: WodDetailsCoordinator.Mode = {
                switch routeSegment {
                case .new: return .new
                case .existing(let wodRouteId): return .view(wodRouteId)
                }
            }()
            coordinators.append(WodDetailsCoordinator(store: store, mode: mode))
        }        
        return coordinators
    }
    
    func start(route: Route?) {
        guard !(route ?? []).isEmpty else {
            let defaultRoute = WodsCoordinator.RouteSegment.list.route()
            store.route(.push(defaultRoute))
            return
        }
        setRoute(route, completionHandler: {})
    }
    
    // MARK - ViewControllerLifecycleDelegate

    @objc func didMove(toParentViewController parentViewController: UIViewController?, viewController: UIViewController) {
        if parentViewController == nil, let coordinator = coordinators.popLast() {
            store.setRoute(.pop(coordinator.route))
        }
    }
    
}
