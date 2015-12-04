//
//  WatchInterfaceController.swift
//  ActiveBAC
//
//  Created by liblabs-mac on 12/3/15.
//  Copyright © 2015 team[0]. All rights reserved.
//

import WatchKit
import Foundation



class WatchInterfaceController: WKInterfaceController {

    
    
    @IBAction func mainButtonClicked() {
        let dict = ["test" : 4] //your dictionary/request to sent to the iPhone
        
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
