//
//  WodDetailsCoordinator.swift
//  WODCordux
//
//  Created by Will Ellis on 2/24/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

typealias WodId = Int

final class WodDetailsCoordinator: Coordinator {

    enum RouteSegment: RouteConvertible {
        static let baseSegment = "details"
        static let newSegment = "new"
        case new
        case existing(WodRouteId)
        func route() -> Route {
            switch self {
            case .new: return RouteSegment.baseSegment.route() + RouteSegment.newSegment.route()
            case .existing(let wodRouteId): return RouteSegment.baseSegment.route() + wodRouteId.route()
            }
        }
        static func trim(fromRoute route: Route) -> (routeSegment: RouteSegment, trimmedRoute: Route)? {
            var trimmedRoute = route
            guard let firstSegment = trimmedRoute.first, firstSegment.route() == baseSegment.route() else { return nil }

            trimmedRoute = Route(trimmedRoute.dropFirst())
            guard let secondSegment = trimmedRoute.first else { return nil }

            if let wodRouteId = WodRouteId(secondSegment) {
                return (routeSegment: RouteSegment.existing(wodRouteId), trimmedRoute: Route(trimmedRoute.dropFirst()))
            } else if secondSegment.route() == newSegment.route() {
                return (routeSegment: RouteSegment.new, trimmedRoute: Route(trimmedRoute.dropFirst()))
            } else {
                return nil
            }
        }
    }

    enum Mode {
        case new
        case view(WodRouteId)
        case edit(WodRouteId)
    }

    var store: Store
    let wodDetailsViewController: WodDetailsViewController
    var rootViewController: UIViewController { return wodDetailsViewController }
    
    let storyboard = UIStoryboard(name: "WodDetails", bundle: nil)
    
    var mode: Mode
    public var route: Route {
        switch mode {
        case .view(let wodRouteId), .edit(let wodRouteId): return RouteSegment.existing(wodRouteId).route()
        case .new: return RouteSegment.new.route()
        }
    }
    
    init(store: Store, mode: Mode) {
        self.store = store
        self.mode = mode
        
        wodDetailsViewController = storyboard.instantiateViewController(withIdentifier: "WodDetails") as! WodDetailsViewController
    }
    
    func start(route: Route?) {
        wodDetailsViewController.inject(handler: self)
        wodDetailsViewController.corduxContext = Context(routeSegment: route, lifecycleDelegate: self)
    }
    
    
    func prepareForRoute(_ route: Route?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func setRoute(_ newRoute: Route?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}

extension WodDetailsCoordinator: ViewControllerLifecycleDelegate {
    @objc func viewWillAppear(_ animated: Bool, viewController: UIViewController) {
        if viewController === wodDetailsViewController {
            switch mode {
            case .view(let wodRouteId), .edit(let wodRouteId):
                store.subscribe(wodDetailsViewController, WodDetailsViewModel.makeInit(with: wodRouteId))
            case .new:
                break
            }
        }
    }

    @objc func viewWillDisappear(_ animated: Bool, viewController: UIViewController) {
        if viewController === wodDetailsViewController {
            store.unsubscribe(wodDetailsViewController)
        }
    }
}

extension WodDetailsViewController: Renderer {}

extension WodDetailsViewModel {
    static func makeInit(with wodRouteId: WodRouteId) -> (AppState) -> WodDetailsViewModel {
        return { (state) -> WodDetailsViewModel in
            guard case .initialized(let browsingState) = state.initialization, let wod = browsingState.wods[safe: wodRouteId] else {
                return WodDetailsViewModel()
            }
            
            return WodDetailsViewModel(name: wod.name, content: wod.content)
        }
    }
}

extension WodDetailsCoordinator: WodDetailsHandler {
    func performAction() {
        // TODO: WTE -
    }
}
