//
//  CodeSamplesViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 15/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit
import SwiftyJSON

class CodeSamplesViewController: UIViewController {

    var customers = [Customer]()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var dict = [
            "CustomerID" : 5,
            "CustomerName" : "Alex",
            "Birthday" : "20/09/1991",
            "items" : [
                [
                    "CardDesignItemID" : 6,
                    "FontID" : 3
                ],
                [
                    "CardDesignItemID" : 7,
                    "FontID" : 43
                ]
            ],
            "Address": [
                "Ad1" : "32 haughgate close"
            ]
        ]
        
        var json: JSON = JSON(dict)
        
        var customer:Customer = Customer.createObjectFromJson(json)
        println(customer.items[1].fontID)
        println(customer.birthday)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func sampleRequest() {
        
        CompresJsonRequest.create("http://alex.bechmann.co.uk/compresjson/api/Customers/1", parameters: nil, method: .GET)
        
        
        CompresJsonRequest.create("http://alex.bechmann.co.uk/compresjson/api/Customers/5", parameters: nil, method: .GET)
            
        .onDownloadSuccess { (json, request) -> () in
            
            println(json)
            
            let customer = Customer()
            customer.CustomerID = json["CustomerID"].intValue
            customer.CustomerName = json["CustomerName"].stringValue
        }
    }

    func sampleRequest2() {
        
        // doesnt work // example of normal api
        
        var params = [
            "CustomerID" : 5,
            "Address1" : "10 High Street",
            "EMail" : "sebra54@gmail.com",
            "Discount" : 100,
            "CurrencyCode" : "GBP",
            "CustomerName" : "Sebastian",
        ]
        
        JsonRequest.create("http://mysite.com/sample/api/Customers/5", parameters: params, method: .PUT)
            
        .onDownloadSuccess { (json, request) -> () in
            
            let customer = Customer()
            customer.CustomerID = json["CustomerID"].intValue
            customer.CustomerName = json["CustomerName"].stringValue
            
        }.onDownloadFinished { () -> () in
            
            println("request finished")
        }
    }
    
    func sampleRequest3() {
        
        CompresJsonRequest.create("http://alex.bechmann.co.uk/compresjson/api/Customers/1", parameters: nil, method: .GET)
        
        .onDownloadFailure { (error, alert) -> () in
            
            alert.show()
            println(error)
        }
    }
    
    func refresh(refreshControl: UIRefreshControl?) {
        
        Customer.webApiGetMultipleObjects(Customer.self, completion: { (objects) -> () in
            
            self.customers = objects
            
        })?.onDownloadFinished({ () -> () in
            
            refreshControl?.endRefreshing()
            self.tableView.reloadData()
            
        }).onDownloadFailure { (error, alert) -> () in
            
            alert.show()
            println(error)
        }
    }
    
    func alamofireRequestAccess() {
        
        CompresJsonRequest.create("", parameters: nil, method: .POST).req
    }
}
