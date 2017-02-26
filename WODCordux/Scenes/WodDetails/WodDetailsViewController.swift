//
//  WodDetailsViewController.swift
//  WODCordux
//
//  Created by Will Ellis on 2/24/17.
//  Copyright © 2017 Will Ellis Inc. All rights reserved.
//

import UIKit


struct WodDetailsViewModel {
    var name: String = ""
    var content: String = ""
}

protocol WodDetailsHandler {
    func performAction()
}

final class WodDetailsViewController: UIViewController {
    
    @IBOutlet var content: UILabel!
    
    var handler: WodDetailsHandler?
    
    func inject(handler: WodDetailsHandler) {
        self.handler = handler
    }    
    
    func render(_ viewModel: WodDetailsViewModel) {
        navigationItem.title = viewModel.name
        content.text = viewModel.content
    }
}
