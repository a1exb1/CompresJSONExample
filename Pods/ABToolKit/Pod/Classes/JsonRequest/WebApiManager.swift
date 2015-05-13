//
//  WebApiUrlManager.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 29/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit



public class WebApiManager: NSObject {
   
    var domain: String?
    var restKey: String?
    //var webApiManagerDelegate: WebApiManagerDelegate?
    
    public func setupUrlsForREST(restKey: String, overrideDomain: String?) -> WebApiManager {
        
        self.domain = overrideDomain
        self.restKey = restKey
        
        return self
    }
    
    public func setupUrlsForREST(key: String) -> WebApiManager {
        
        return setupUrlsForREST(key, overrideDomain: nil)
    }
    
    private func getDomain() -> String{
        
        var domain = ""
        
        if let d = WebApiDefaults.sharedInstance().domain {
            
            domain = d
        }
        
        if let d = self.domain {
            
            domain = d
        }
        
        return domain
    }
    
    private func mutableUrl(id: Int) -> String? {
        
        return validRestUrlSet() ? "\(getDomain())/api/\(restKey!)/\(id)" : nil
    }
    
    private func staticUrl() -> String? {
        
        return validRestUrlSet() ? "\(getDomain())/api/\(restKey!)" : nil
    }
    
    public func updateUrl(id: Int?) -> String? {
        
        if let id = id {
            
            return mutableUrl(id)
        }
        
        return nil
    }
    
    public func insertUrl() -> String? {
        
        return staticUrl()
    }
    
    public func getUrl(id: Int) -> String? {
        
        return mutableUrl(id)
    }
    
    public func getMultipleUrl() -> String? {
        
        return staticUrl()
    }
    
    public func deleteUrl(id: Int?) -> String? {
        
        if let id = id {
            
            return mutableUrl(id)
        }
        
        return nil
    }
    
    public func validRestUrlSet() -> Bool {
     
        return restKey != nil
    }
}
