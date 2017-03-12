//
//  WodsCoordinator.swift
//  WODCordux
//
//  Created by Will Ellis on 2/17/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

final class WodsCoordinator: Coordinator {
    enum RouteSegment: String, RouteConvertible {
        case list
    }
    
    var store: Store
    var rootViewController: UIViewController { return wodsViewController }
    var route: Route { return RouteSegment.list.route() }

    let storyboard = UIStoryboard(name: "Wods", bundle: nil)
    let wodsViewController: WodsViewController
    
    init(store: Store) {
        self.store = store
        wodsViewController = storyboard.instantiateViewController(withIdentifier: "Wods") as! WodsViewController
    }
    
    func start(route: Route?) {
        wodsViewController.inject(handler: self)
        wodsViewController.corduxContext = Context(routeSegment: route, lifecycleDelegate: self)
    }
    
    func prepareForRoute(_ route: Route?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func setRoute(_ route: Route?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension WodsCoordinator: ViewControllerLifecycleDelegate {
    @objc func viewWillAppear(_ animated: Bool, viewController: UIViewController) {
        if viewController === wodsViewController {
            store.subscribe(wodsViewController, WodsViewModel.makeInit())
        }
    }
    
    @objc func viewWillDisappear(_ animated: Bool, viewController: UIViewController) {
        if viewController === wodsViewController {
            store.unsubscribe(wodsViewController)
        }
    }
}

extension WodsViewController: Renderer {}

extension WodsViewModel {
    
    static func makeInit() -> (AppState) -> WodsViewModel {
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
    func presentWodDetails(for wodIndex: Int) {
        store.route(.push(WodDetailsCoordinator.RouteSegment.details.route() + wodIndex))
    }
    
}
