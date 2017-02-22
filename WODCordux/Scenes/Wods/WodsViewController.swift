//
//  WodsViewController.swift
//  WODCordux
//
//  Created by Will Ellis on 2/17/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import UIKit

struct WodTableViewCellViewModel {
    var title: String = ""
    var content: String = ""
}

struct WodsViewModel {
    var wodTableViewCellViewModels: [WodTableViewCellViewModel] = []
}

protocol WodsHandler {
    func performAction()
}

final class WodsViewController: UIViewController {
    
    var handler: WodsHandler?
    
    func inject(handler: WodsHandler) {
        self.handler = handler
    }
    
    func render(_ viewModel: WodsViewModel) {
        // TODO WTE
    }
}
