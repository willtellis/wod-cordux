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
    func presentWodDetails(for wodIndex: Int)
}

final class WodsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var viewModel: WodsViewModel = WodsViewModel()
    var handler: WodsHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationItem.title = NSLocalizedString("Wods", comment: "")
    }
        
    func inject(handler: WodsHandler) {
        self.handler = handler
    }
    
    func render(_ viewModel: WodsViewModel) {
        self.viewModel = viewModel
        tableView.reloadData()
    }
}

extension WodsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.wodTableViewCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WodsTableViewCell.reusableIdentifier, for: indexPath) as! WodsTableViewCell
        let cellViewModel = viewModel.wodTableViewCellViewModels[indexPath.row]
        cell.render(cellViewModel)
        return cell
    }
}

extension WodsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handler?.presentWodDetails(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


final class WodsTableViewCell: UITableViewCell, ClassNameIdentifiable {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var content: UILabel!
    
    func render(_ viewModel: WodTableViewCellViewModel) {
        title.text = viewModel.title
        content.text = viewModel.content
    }
}
