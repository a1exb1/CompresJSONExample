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
   
    public override class func requestObjectWithID(id: Int) -> CompresJsonRequest? {
        
        if let url = self.webApiUrls().getUrl(id) {
            
            return CompresJsonRequest.create(url, parameters: nil, method: .GET) as CompresJsonRequest
        }
        
        return nil
    }
    
    public class func webApiGetObjectByID< T : JSONObject >(type: T.Type, id:Int, completion: (object:T) -> () ) -> CompresJsonRequest? {
        
        if let url = T.webApiUrls().getUrl(id) {
            
            return CompresJsonRequest.create(url, parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in
                
                completion(object: self.createObjectFromJson(json) as T)
                
            } as? CompresJsonRequest
        }
        
        return nil
    }
    
    public class func webApiGetMultipleObjects< T : JSONObject >(type: T.Type, completion: (objects:[T]) -> () ) -> CompresJsonRequest? {
        
        return self.webApiGetMultipleObjects(type, skip: 0, take: 20) { (objects) -> () in
            completion(objects: objects)
        }
    }
    
    public class func webApiGetMultipleObjects< T : JSONObject >(type: T.Type, skip:Int, take:Int, completion: (objects:[T]) -> () ) -> CompresJsonRequest? {
        
        if let url = T.webApiUrls().getMultipleUrl() {
        
            var params = [
                "skip" : skip,
                "take" : take
            ]
            
            return CompresJsonRequest.create(url, parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in
                
                var objects = [T]()
                
                for (index: String, objectJSON: JSON) in json {
                    
                    var object:T = self.createObjectFromJson(objectJSON)
                    objects.append(object)
                }
                
                completion(objects: objects)
                
            } as? CompresJsonRequest
        }
        
        return nil
    }
    
    // MARK: - Web Api Methods
    
    public override func webApiInsert() -> CompresJsonRequest?{
        
        return webApiInsert(nil)
    }
    
    public override func webApiInsert(keysToInclude: Array<String>?) -> CompresJsonRequest?{
        
        if let url = self.dynamicType.webApiUrls().insertUrl() {
            
            return CompresJsonRequest.create(url, parameters: self.convertToDictionary(nil, includeNestedProperties: false), method: .POST) as CompresJsonRequest
        }
        else{
            
            println("web api url not set")
            
        }
        
        return nil
    }
    
    public override func webApiUpdate() -> CompresJsonRequest?{
        
        return webApiUpdate(nil)
    }
    
    public override func webApiUpdate(keysToInclude: Array<String>?) -> CompresJsonRequest?{
        
        if let url = self.dynamicType.webApiUrls().updateUrl(webApiManagerDelegate?.webApiRestObjectID()) {
            
            return CompresJsonRequest.create(url, parameters: self.convertToDictionary(keysToInclude, includeNestedProperties: false), method: .PUT) as CompresJsonRequest
        }
        else{
            
            println("web api url not set")
        }
        
        return nil
    }
    
    public override func webApiDelete() -> CompresJsonRequest?{
        
        if let url = self.dynamicType.webApiUrls().deleteUrl(webApiManagerDelegate?.webApiRestObjectID()) {
            
            return CompresJsonRequest.create(url, parameters: nil, method: .DELETE) as CompresJsonRequest
        }
        else{
            
            println("web api url not set")
        }
        
        return nil
    }
    
}
