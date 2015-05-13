//
//  CompresJSONObject.swift
//  CompresJSON
//
//  Created by Alex Bechmann on 12/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import SwiftyJSON

public class CompresJSONObject: JSONObject {
   
    public class func compresJsonWebApiGetObjectByID< T : JSONObject >(type: T.Type, id:Int, completion: (object:T) -> () ) {
        
        if let url = T.webApiUrls().getUrl(id) {
            
            CompresJsonRequest.create(url, parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in
                
                completion(object: self.createObjectFromJson(json) as T)
            }
        }
    }
    
    public class func compresJsonWebApiGetMultipleObjects< T : JSONObject >(type: T.Type, completion: (objects:[T]) -> () ) {
        
        if let url = T.webApiUrls().getMultipleUrl() {
            
            CompresJsonRequest.create(url, parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in
                
                var objects = [T]()
                
                for (index: String, objectJSON: JSON) in json {
                    
                    var object:T = self.createObjectFromJson(objectJSON)
                    objects.append(object)
                }
                
                completion(objects: objects)
            }
        }
    }
    
    // MARK: - Web Api Methods
    
    public func compresJSONWebApiInsert() -> CompresJsonRequest?{
        
        return compresJSONWebApiInsert(nil)
    }
    
    public func compresJSONWebApiInsert(keysToInclude: Array<String>?) -> CompresJsonRequest?{
        
        if let url = self.dynamicType.webApiUrls().insertUrl() {
            
            return CompresJsonRequest.create(url, parameters: self.convertToDictionary(nil, includeNestedProperties: false), method: .POST) as CompresJsonRequest
        }
        else{
            
            println("web api url not set")
            
        }
        
        return nil
    }
    
    public func compresJSONWebApiUpdate() -> JsonRequest?{
        
        return compresJSONWebApiUpdate(nil)
    }
    
    public func compresJSONWebApiUpdate(keysToInclude: Array<String>?) -> CompresJsonRequest?{
        
        if let url = self.dynamicType.webApiUrls().updateUrl(webApiManagerDelegate?.webApiRestObjectID()) {
            
            return CompresJsonRequest.create(url, parameters: self.convertToDictionary(keysToInclude, includeNestedProperties: false), method: .PUT) as CompresJsonRequest
        }
        else{
            
            println("web api url not set")
        }
        
        return nil
    }
    
    public func compresJSONWebApiDelete() -> CompresJsonRequest?{
        
        if let url = self.dynamicType.webApiUrls().deleteUrl(webApiManagerDelegate?.webApiRestObjectID()) {
            
            return CompresJsonRequest.create(url, parameters: nil, method: .DELETE) as CompresJsonRequest
        }
        else{
            
            println("web api url not set")
        }
        
        return nil
    }
    
}