//
//  WebApiUrlManager.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 29/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

private let kKey = CompresJSON.sharedInstance().settings.encryptionKey
private let kEncryptComponents = CompresJSON.sharedInstance().settings.encryptUrlComponents

public class WebApiManager: NSObject {
   
    public var domain: String?
    public var restKey: String?
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
        
        if kEncryptComponents {
            
            //var secretComponent = Encryptor.encrypt("api", key: kKey)
            var eRestKey = encryptSecretUrlComponent(restKey!)
            var eID = encryptSecretUrlComponent("\(id)")
            var secretRestApiPrefix = "apih" // encryptSecretUrlComponent("api")
            
            return validRestUrlSet() ? "\(getDomain())/\(secretRestApiPrefix)/\(eRestKey)/\(eID)" : nil
        }
        
        return validRestUrlSet() ? "\(getDomain())/api/\(restKey!)/\(id)" : nil
    }
    
    private func staticUrl() -> String? {
        
        if kEncryptComponents {
            
            var eRestKey = encryptSecretUrlComponent(restKey!)
            var secretRestApiPrefix = "apih" // encryptSecretUrlComponent("api")
            
            return validRestUrlSet() ? "\(getDomain())/\(secretRestApiPrefix)/\(eRestKey)" : nil
        }
        
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
    
    private func encryptSecretUrlComponent(str: String) -> String {
        
        return Encryptor.encrypt(str, key: kKey)
    }
}
