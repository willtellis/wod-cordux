//
//  WodDetailsCoordinator.swift
//  WODCordux
//
//  Created by Will Ellis on 2/24/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

final class WodDetailsCoordinator: Coordinator {

    func needsToPrepareForRoute(_: Route?) -> Bool {
        return false
    }

    enum RouteSegment: String, RouteConvertible {
        case details
    }

    var store: Store
    let wodDetailsViewController: WodDetailsViewController
    var rootViewController: UIViewController { return wodDetailsViewController }
    
    let storyboard = UIStoryboard(name: "WodDetails", bundle: nil)
    
    var wodRouteId: WodRouteId?
    public var route: Route { return RouteSegment.details.route() + (wodRouteId?.route() ?? []) }
    
    init(store: Store, wodRouteId: WodRouteId? = nil) {
        self.store = store
        self.wodRouteId = wodRouteId
        
        wodDetailsViewController = storyboard.instantiateViewController(withIdentifier: "WodDetails") as! WodDetailsViewController
    }
    
    func start(route: Route?) {
        wodDetailsViewController.inject(handler: self)
    }
    
    
    func prepareForRoute(_ route: Route?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func setRoute(_ newRoute: Route?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}

extension WodDetailsCoordinator: ViewControllerLifecycleDelegate {
    @objc func viewDidLoad(viewController: UIViewController) {
        if viewController === wodDetailsViewController, let wodRouteId = wodRouteId {
            store.subscribe(wodDetailsViewController, WodDetailsViewModel.makeInit(with: wodRouteId))
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
