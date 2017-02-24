//
//  WodsCoordinator.swift
//  WODCordux
//
//  Created by Will Ellis on 2/17/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

final class WodsCoordinator: NavigationControllerCoordinator {
    enum RouteSegment: String, RouteConvertible {
        case list
    }
    
    var store: Store
    let navigationController: UINavigationController

    let storyboard = UIStoryboard(name: "Wods", bundle: nil)
    let wodsViewController: WodsViewController
    
    init(store: Store) {
        self.store = store
        
        wodsViewController = storyboard.instantiateViewController(withIdentifier: "Wods") as! WodsViewController
        navigationController = UINavigationController(rootViewController: wodsViewController)
    }
    
    func start(route: Route?) {
        wodsViewController.inject(handler: self)
        wodsViewController.corduxContext = Context(routeSegment: RouteSegment.list, lifecycleDelegate: self)

        let segments = parse(route: route)
        guard !segments.isEmpty else {
            store.setRoute(.push(RouteSegment.list))
            return
        }
    }
    
    func parse(route: Route?) -> [RouteSegment] {
        return route?.flatMap({ RouteSegment.init(rawValue: $0) }) ?? []
    }
    
    func updateRoute(_ route: Route, completionHandler: @escaping () -> Void) {
        completionHandler()
    }

}

extension WodsCoordinator: ViewControllerLifecycleDelegate {
    @objc func viewDidLoad(viewController: UIViewController) {
        if viewController === wodsViewController {
            store.subscribe(wodsViewController, WodsViewModel.make())
        }
    }
    
    @objc func didMove(toParentViewController parentViewController: UIViewController?, viewController: UIViewController) {
        guard parentViewController == nil else {
            return
        }
        
        popRoute(viewController)
    }
}

extension WodsViewController: Renderer {}

extension WodsViewModel {
    static func make() -> (AppState) -> WodsViewModel {
        return { (state) -> WodsViewModel in
            guard case .initialized(let browsingState) = state.initialization else {
                return WodsViewModel()
            }
            return WodsViewModel(
                wodTableViewCellViewModels: browsingState.wods.map { WodTableViewCellViewModel(title: $0.name, content: $0.content) }
            )
        }
    }
}



extension WodsCoordinator: WodsHandler {
    func performAction() {
        // TODO: WTE -
    }
}
