//
//  Encryptor.swift
//  EncryptionTests3
//
//  Created by Alex Bechmann on 08/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

private let kAnalyzer = JavaScriptAnalyzer.sharedInstance()
private let kScriptPath = "encryptor_compressor"

class Encryptor: NSObject {
   
    class func encrypt(str: String, key: String) -> String {
        
        Encryptor.printErrorIfEncryptionKeyIsNotSet()
        
        kAnalyzer.loadScript(kScriptPath)
        return kAnalyzer.executeJavaScriptFunction("Encrypt", args: [str, key]).toString()
    }
    
    class func decrypt(str: String, key: String) -> String {
        
        Encryptor.printErrorIfEncryptionKeyIsNotSet()
        
        kAnalyzer.loadScript(kScriptPath)
        return kAnalyzer.executeJavaScriptFunction("Decrypt", args: [str, key]).toString()
    }
    
    class func printErrorIfEncryptionKeyIsNotSet() {
        
        if CompresJSON.sharedInstance().settings.encryptionKey == "" {
            
            println("Encryption key not set: add to appdelegate: CompresJSON.sharedInstance().settings.encryptionKey = xxxx")
        }
    }
    
}

