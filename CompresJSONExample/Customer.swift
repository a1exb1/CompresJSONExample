//
//  Customer.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 14/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

class Customer: CompresJSONObject {
 
    var CustomerID: Int = 0
    var CurrencyCode: Int = 0
    var CustomerName: String = ""
    
    // MARK: - Web api methods
    
    override class func webApiUrls() -> WebApiManager {
        
        return WebApiManager().setupUrlsForREST("Customers")
    }
    
    override func webApiRestObjectID() -> Int? {
        
        return CustomerID
    }
}
