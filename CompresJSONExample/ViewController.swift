//
//  ViewController.swift
//  CompresJSONExample
//
//  Created by Alex Bechmann on 13/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        CardDesignItem.compresJsonWebApiGetObjectByID(CardDesignItem.self, id: 8386, completion: { (object) -> () in
            
            var item:CardDesignItem = object
            println(item.CardDesignItemID)
            item.ItemText = "hello test 10 !!! big kfjljlk"
            //item.CardDesignItemID = 8386 // REMEMBER ID
            item.compresJSONWebApiUpdate()?.onDownloadSuccess({ (json, request) -> () in
                
                item = CardDesignItem.createObjectFromJson(json)
                println("after update: \(item.ItemText)")
            })
            
        })
        
        CardDesignItem.compresJsonWebApiGetMultipleObjects(CardDesignItem.self, completion: { (objects) -> () in
            
            println(objects.count)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

