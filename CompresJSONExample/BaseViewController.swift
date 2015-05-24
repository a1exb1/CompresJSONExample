//
//  BaseViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 24/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setupTableView(tableView: UITableView, delegate: UITableViewDelegate, dataSource:UITableViewDataSource) {
        
        view.addSubview(tableView)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.fillSuperView(UIEdgeInsetsZero)
        
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.AllEvents)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(refreshControl: UIRefreshControl?) {
        
    }

}
