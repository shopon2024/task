//
//  ViewController.swift
//  Task
//
//  Created by Habib on 13/3/19.
//  Copyright © 2019 Habib. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //***** MARK: - Private Methods
    private func setup() {
        tableView.register(RepoCell.self, forCellReuseIdentifier: RepoCell.reuseIdentifier)
    }
    
    
    
    //***** MARK: TableView Delegate & DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, withType: RepoCell.self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
}


