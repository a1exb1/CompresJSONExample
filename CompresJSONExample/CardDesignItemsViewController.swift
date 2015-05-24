//
//  ViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 13/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class CardDesignItemsViewController: BaseViewController{

    var tableView = UITableView()
    var items = [CardDesignItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView(tableView, delegate: self, dataSource: self)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh(nil)
    }
    
    override func refresh(refreshControl: UIRefreshControl?) {
        
        CardDesignItem.webApiGetMultipleObjects(CardDesignItem.self, completion: { (objects) -> () in
            
            self.items = objects
            
        })?.onDownloadFinished({ () -> () in
            
            refreshControl?.endRefreshing()
            self.tableView.reloadData()
            
        }).onDownloadFailure({ (error, alert) -> () in
            
            alert.show()
        })
    }
    
    func add() {
        
        editItem(CardDesignItem())
    }
    
    func editItem(item: CardDesignItem) {
        
        var v = SaveCardDesignItemViewController()
        v.item = item
        self.navigationController?.pushViewController(v, animated: true)
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
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = items[indexPath.row]
        
        editItem(item)
    }
    
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let item = items[indexPath.row]
            
            item.webApiDelete()?.onDownloadFinished({ () -> () in
                
                self.refresh(nil)
            })
        }
    }
}

