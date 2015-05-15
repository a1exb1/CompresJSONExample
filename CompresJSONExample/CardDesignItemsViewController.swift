//
//  ViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 13/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

class CardDesignItemsViewController: UIViewController{

    var tableView = UITableView()
    var items = [CardDesignItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setupTableView()
        refresh(nil)
    }
    
    func refresh(refreshControl: UIRefreshControl?) {
        
        items = []
        self.tableView.reloadData()
        
        CardDesignItem.compresJsonWebApiGetMultipleObjects(CardDesignItem.self, completion: { (objects) -> () in
            
            self.items = objects
            self.tableView.reloadData()
            refreshControl?.endRefreshing()
        })
        
    }

    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        tableView.fillSuperView(UIEdgeInsetsZero)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.AllEvents)
        tableView.addSubview(refreshControl)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CardDesignItemsViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.ItemText
        cell.detailTextLabel?.text = "FontID: \(item.FontID)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = items[indexPath.row]
        
        item.ItemText = "Some new string"
        
        item.compresJSONWebApiUpdate()?.onDownloadSuccess({ (json, request) -> () in
            
            var i:CardDesignItem = CardDesignItem.createObjectFromJson(json)
            println("afer update: \(i.ItemText)")
            self.tableView.reloadData()
        })
        
    }
}

