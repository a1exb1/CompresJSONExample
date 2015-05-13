//
//  CompresJSON.swift
//  EncryptionTests3
//
//  Created by Alex Bechmann on 08/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

let kCompresJSONSharedInstance = CompresJSON()

public class CompresJSON: NSObject {
   
    public class func sharedInstance() -> CompresJSON {
        
        return kCompresJSONSharedInstance
    }
    
    public var settings: CompresJSONSettings = CompresJSONSettings()
    
    public class func encryptAndCompressAsNecessary(str: String) -> String {
        
        CompresJSON.printErrorIfEncryptionKeyIsNotSet()
        
        var compressedString = str.compress()
        
        return Encryptor.encrypt(compressedString, key: CompresJSON.sharedInstance().settings.encryptionKey)
    }

    public class func decryptAndDecompressAsNecessary(str: String) -> String {
            
        CompresJSON.printErrorIfEncryptionKeyIsNotSet()

        var decryptedString = Encryptor.decrypt(str, key: CompresJSON.sharedInstance().settings.encryptionKey)

        return decryptedString.decompress()
    }
    
    public class func printErrorIfEncryptionKeyIsNotSet() {
    
        if CompresJSON.sharedInstance().settings.encryptionKey == "" {
        
            println("Encryption key not set: add to appdelegate: CompresJSON.sharedInstance().settings.encryptionKey = xxxx")
        }
    }
    
}
