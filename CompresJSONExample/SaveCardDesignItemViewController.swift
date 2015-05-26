//
//  SaveCardDesignItemViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 24/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit
import SwiftyJSON

class SaveCardDesignItemViewController: BaseViewController {

    var item = CardDesignItem()
    let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    var properties: Array<(labelValue: String, propertyValue: AnyObject)> = []
    var textFields: Array<UITextField> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView(tableView, delegate: self, dataSource: self)
        
        tableView.registerClass(EditingTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
        self.title = item.CardDesignItemID > 0 ? "Edit card" : "New card"
        
        setProperties()
    }
    
    func setProperties() {
    
        properties = [
            (labelValue: "Item Text", propertyValue: item.ItemText),
            (labelValue: "FontID", propertyValue: item.fontID),
            (labelValue: "Card Design ID", propertyValue: item.CardDesignID)
        ]
    }
    
    override func refresh(refreshControl: UIRefreshControl?) {
        
        CardDesignItem.requestObjectWithID(item.CardDesignItemID)?.onDownloadSuccess({ (json, request) -> () in
            
            self.item = CardDesignItem.createObjectFromJson(json)
            
        }).onDownloadFinished({ () -> () in
            
            refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func save() {
        
        var responseJson: JSON?
        
        item.ItemText = textFields[0].text
        item.fontID = textFields[1].text.toInt()!
        item.CardDesignID = textFields[2].text.toInt()!
        
        var request: CompresJsonRequest?
        
        if item.CardDesignItemID == 0 {
            
            request = item.webApiInsert()
        }
        else {
            
            request = item.webApiUpdate()
        }
        
        request?.onDownloadSuccess({ (json, request) -> () in
            
            responseJson = json
            
            self.item = CardDesignItem.createObjectFromJson(json)
            self.navigationController?.popViewControllerAnimated(true)
            
        }).onDownloadFailure({ (error, alert) -> () in
            
            alert.show()
            
        }).alamofireRequest?.responseJSON(options: NSJSONReadingOptions.AllowFragments, completionHandler: { (request, response, obj, error) -> Void in
            
            println("-- request start --")
            println("HTTP Method: \(request.HTTPMethod!)")
            println("URL: \(request.URLString)")
            let contentLength: AnyObject = response!.allHeaderFields["Content-Length"]!
            var length: CGFloat = CGFloat("\(contentLength)".toInt()!) / 10240
            let l = NSString(format: "%.02f", length)
            println("Content-Length: \(l)kb")
            println("Data in HTTP body:")
            println(obj!)
            println("Decoded JSON: ")
            println(responseJson!)
            println("-- request end --")
        })
    }
}

extension SaveCardDesignItemViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return properties.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! EditingTableViewCell
        let property = properties[indexPath.row]
        
        cell.label.text = property.labelValue
        cell.textField.text = "\(property.propertyValue)"
        
        self.textFields.append(cell.textField)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditingTableViewCell
        
        cell.textField.becomeFirstResponder()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
