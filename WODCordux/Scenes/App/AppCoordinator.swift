//
//  AppCoordinator.swift
//  WODCordux
//
//  Created by Will Ellis on 2/16/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import Foundation
import Cordux

final class AppCoordinator: SceneCoordinator {
    enum RouteSegment: String, RouteConvertible {
        case wods
    }
    
    let store: Store
    let container: UIViewController
    
    var currentScene: Scene?
    
    var rootViewController: UIViewController {
        return container
    }
    
    init(store: Store, container: UIViewController) {
        self.store = store
        self.container = container
    }
    
    func start(route: Route?) {
        store.rootCoordinator = self
        // TODO: WTE - Something like store.subscribe(self, RouteSubscription.init) to get ability to change out presented coordinator when route changes
    }
    
    func coordinatorForTag(_ tag: String) -> (coordinator: AnyCoordinator, started: Bool)? {
        guard let segment = RouteSegment(rawValue: tag) else { return nil }
        switch segment {
        case .wods:
            return (WodsCoordinator(store: store), false)
        }
    }
    
    func presentCoordinator(_ coordinator: AnyCoordinator?, completionHandler: @escaping () -> Void) {
        
        let container = self.container
        let old = container.childViewControllers.first
        let new = coordinator?.rootViewController
        
        old?.willMove(toParentViewController: nil)
        
        if let new = new {
            container.addChildViewController(new)
            container.view.addSubview(new.view)
            var constraints: [NSLayoutConstraint] = []
            constraints.append(new.view.leftAnchor.constraint(equalTo: container.view.leftAnchor))
            constraints.append(new.view.rightAnchor.constraint(equalTo: container.view.rightAnchor))
            constraints.append(new.view.topAnchor.constraint(equalTo: container.view.topAnchor))
            constraints.append(new.view.bottomAnchor.constraint(equalTo: container.view.bottomAnchor))
            NSLayoutConstraint.activate(constraints)
        }
        
        new?.view.alpha = 0
        UIView.animate(withDuration: 1.0, animations: {
            old?.view.alpha = 0
            new?.view.alpha = 1
        }, completion: { _ in
            old?.view.removeFromSuperview()
            old?.removeFromParentViewController()
            new?.didMove(toParentViewController: container)
            completionHandler()
        })
    }
    
}
