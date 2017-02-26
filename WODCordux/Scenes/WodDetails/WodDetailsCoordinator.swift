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
    
    var store: Store
    let wodDetailsViewController: WodDetailsViewController
    var rootViewController: UIViewController { return wodDetailsViewController }
    
    let storyboard = UIStoryboard(name: "WodDetails", bundle: nil)
    
    init(store: Store) {
        self.store = store
        
        wodDetailsViewController = storyboard.instantiateViewController(withIdentifier: "Wods") as! WodDetailsViewController
    }
    
    func start(route: Route?) {
        guard let route = route, let wodID = route.first else {
            return
        }
        wodDetailsViewController.inject(handler: self)
        wodDetailsViewController.corduxContext = Context(routeSegment: wodID, lifecycleDelegate: self)
        
        store.setRoute(.push(wodID))
    }
    
    public var route: Route { return rootViewController.corduxContext?.routeSegment?.route() ?? [] }
    
    func prepareForRoute(_ route: Route?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func setRoute(_ newRoute: Route?, completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard let newRoute = newRoute, newRoute != route, let wodIndex = Int(route.first ?? "") else { return }
        store.unsubscribe(wodDetailsViewController)
        store.subscribe(wodDetailsViewController, WodDetailsViewModel.makeInit(with: wodIndex))
    }
    
    
    
}

extension WodDetailsCoordinator: ViewControllerLifecycleDelegate {
    @objc func viewDidLoad(viewController: UIViewController) {
        if viewController === wodDetailsViewController, let wodIndex = Int(route.first ?? "") {
            store.subscribe(wodDetailsViewController, WodDetailsViewModel.makeInit(with: wodIndex))
        }
    }
    
    @objc func didMove(toParentViewController parentViewController: UIViewController?, viewController: UIViewController) {
        guard parentViewController == nil else {
            return
        }
        
        guard let routeSegment = route.first else {
            return
        }
        store.setRoute(.pop(routeSegment))
    }
}

extension WodDetailsViewController: Renderer {}

extension WodDetailsViewModel {
    static func makeInit(with wodIndex: Int) -> (AppState) -> WodDetailsViewModel {
        return { (state) -> WodDetailsViewModel in
            guard case .initialized(let browsingState) = state.initialization, let wod = browsingState.wods[safe: wodIndex] else {
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
