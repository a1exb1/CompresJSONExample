//
//  SaveCardDesignItemViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 24/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

class SaveCardDesignItemViewController: BaseViewController {

    var item = CardDesignItem()
    let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    let properties = [
        (propertykey: "ItemText", labelValue: "Item Text")
    ]
    var textFields: Array<UITextField> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView(tableView, delegate: self, dataSource: self)
        
        tableView.registerClass(EditingTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "save")
    }
    
    override func refresh(refreshControl: UIRefreshControl?) {
        
        CardDesignItem.requestObjectWithID(item.CardDesignItemID)?.onDownloadSuccess({ (json, request) -> () in
            
            self.item = CardDesignItem.createObjectFromJson(json)
            
        }).onDownloadFinished({ () -> () in
            
            refreshControl?.endRefreshing()
        })
    }
    
    func save() {
        
        item.ItemText = textFields[0].text
        item.fontID = 5
        item.CardDesignID = 2
        
        var request: CompresJsonRequest?
        
        if item.CardDesignItemID == 0 {
            
            request = item.webApiInsert()
        }
        else {
            
            request = item.webApiUpdate()
        }
        
        request?.onDownloadSuccess({ (json, request) -> () in
            
            self.item = CardDesignItem.createObjectFromJson(json)
            self.navigationController?.popViewControllerAnimated(true)
            
        }).onDownloadFailure({ (error, alert) -> () in
            
            alert.show()
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
        
        switch indexPath.row {
        case 0:
            cell.textField.text = item.ItemText
            break
            
        default:
            break
        }
        
        self.textFields.append(cell.textField)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EditingTableViewCell
        
        cell.textField.becomeFirstResponder()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
