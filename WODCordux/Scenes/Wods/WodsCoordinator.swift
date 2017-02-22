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
    
    var store: Store
    let navigationController: UINavigationController
    var rootViewController: UIViewController { return navigationController }

    let storyboard = UIStoryboard(name: "Wods", bundle: nil)
    let wodsViewController: WodsViewController
    
    init(store: Store) {
        self.store = store
        
        wodsViewController = storyboard.instantiateViewController(withIdentifier: "Wods") as! WodsViewController
        navigationController = UINavigationController(rootViewController: wodsViewController)
    }
    
    func start(route: Route?) {
        wodsViewController.inject(handler: self)
    }
    
    func updateRoute(_ route: Route, completionHandler: @escaping () -> Void) {
        
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
