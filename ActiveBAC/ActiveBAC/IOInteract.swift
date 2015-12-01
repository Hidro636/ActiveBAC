//
//  IOInteraction.swift
//  ActiveBAC
//
//  Created by Student 1 on 12/1/15.
//  Copyright © 2015 team[0]. All rights reserved.
//

import Foundation

class IOController {

    func writeSettings(weight: Double?, gender: NSString?, emergencyNumber: NSString?) {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)
        //saving values
        dict!.objectForKey("UserProfile")!.setObject(weight!, forKey: "weight")
        dict!.objectForKey("UserProfile")!.setObject(gender!, forKey: "gender")
        dict!.objectForKey("UserProfile")!.setObject(emergencyNumber!, forKey: "emergencyNumber")
        //writing to GameData.plist
        dict!.writeToFile(path!, atomically: false)
        //let resultDictionary = NSMutableDictionary(contentsOfFile: path!)
        
    }
    
    func getSettings() -> (weight: Double, gender: String, emergencyNumber: String){
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let userProfile = dict!.objectForKey("UserProfile") as! NSDictionary
        
        return ((userProfile.objectForKey("weight")?.doubleValue)!, (userProfile.objectForKey("gender") as! String?)!, (userProfile.objectForKey("emergencyNumber") as! String?)!)
        
        
    }

}