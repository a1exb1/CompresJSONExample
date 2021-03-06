//
//  User.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

class CardDesignItem: CompresJSONObject {
    
    var CardDesignItemID = 0
    var fontID = 0
    var ColorID = 0
    var ItemText = ""
    var CardDesignID = 0
    
    override func registerClassesForJsonMapping() {

        self.registerKey("fontID", jsonKey: "FontID")
    }
    
    
    // MARK: - Web api methods
    
    override class func webApiUrls() -> WebApiManager {
        
        return WebApiManager().setupUrlsForREST("CardDesignItems")
    }
    
    override func webApiRestObjectID() -> Int? {
        
        return CardDesignItemID
    }
}
