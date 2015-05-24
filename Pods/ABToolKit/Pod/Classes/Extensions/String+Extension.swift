//
//  String+Extension.swift
//  objectmapperTest
//
//  Created by Alex Bechmann on 26/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

public extension String {
    
    public func charCount() -> Int {
        
        return count(self.utf16)
    }
    
    public func contains(find: String) -> Bool {
        
        if let temp = self.rangeOfString(find) {
            return true
        }
        return false
    }
    
    public func replaceString(string:String, withString:String) -> String {
        return self.stringByReplacingOccurrencesOfString(string, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    public func NSDataFromBase64String() -> NSData {
        
        return NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions.allZeros)!
    }
    
    public func urlEncode() -> String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
    }
    
    public func base64Encode() -> String {
        
        return self.toData().base64String()
    }
    
    public func base64Decode() -> String {
        
        return NSDataFromBase64String().toString()
    }
    
    public func toData() -> NSData {
        return (self as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
    }
}