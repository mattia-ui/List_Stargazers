//
//  StargazersTableViewController.swift
//  List Stargazers
//
//  Created by Mattia Cardone on 22/02/2021.
//  Copyright © 2021 Mattia Cardone. All rights reserved.
//

import UIKit

class StargazersTableViewController: UITableViewController {

    let stargazerCell = "stargazerCell"

    var items: [Stargazer] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stargazerCell) as? StargazerTableViewCell

        guard let customCell = cell else {
            return UITableViewCell()
        }

        cell?.configure(items[indexPath.row])
        return customCell
    }
}



