//
//  ViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 13/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import SwiftyJSON

class CardDesignItemsViewController: BaseViewController{

    var tableView = UITableView()
    var items = [CardDesignItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView(tableView, delegate: self, dataSource: self)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add")
        self.title = "Cards"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deselectTableViewSelectedCell(tableView)
        refresh(nil)
    }
    
    override func refresh(refreshControl: UIRefreshControl?) {
        
        var responseJson: JSON?
        
        CardDesignItem.webApiGetMultipleObjects(CardDesignItem.self, completion: { (objects) -> () in
            
            self.items = objects
            
        })?.onDownloadFinished({ () -> () in
            
            refreshControl?.endRefreshing()
            self.tableView.reloadData()
            
        }).onDownloadFailure({ (error, alert) -> () in
            
            alert.show()
            
        }).onDownloadSuccess({ (json, request) -> () in
            
            responseJson = json
            
        }).alamofireRequest?.responseJSON(options: NSJSONReadingOptions.AllowFragments, completionHandler: { (request, response, obj, error) -> Void in
            
            println("-- request start --")
            println("HTTP Method: \(request.HTTPMethod!)")
            println("URL: \(request.URLString)")
            let contentLength: AnyObject = response!.allHeaderFields["Content-Length"]!
            var length: CGFloat = CGFloat("\(contentLength)".toInt()!) / 1024
            let l = NSString(format: "%.02f", length)
            println("Content-Length: \(l)kb")
            println("Data in HTTP body:")
            println(obj!)
            println("Decoded JSON: ")
            println(responseJson!)
            println("-- request end --")
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
            var completedAnimating = false
            var completedDataRequest = false
            
            var completion: () -> ()  = {
                
                if completedAnimating && completedDataRequest {
                    
                    self.refresh(nil)
                }
            }
            
            // Delete item (Web API)
            item.webApiDelete()?.onDownloadFinished({ () -> () in
                
                completedDataRequest = true
                completion()
            })
            
            //Animate Cell removal
            UIView.animateWithDuration(0.0, animations: { () -> Void in
                
                tableView.beginUpdates()
                
                self.items.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                
                tableView.endUpdates()
                
            }, completion: { (complete) -> Void in
                
                completedAnimating = true
                completion()
            })
        }
    }
    
}

