//
//  IOInteraction.swift
//  ActiveBAC
//
//  Created by Student 1 on 12/1/15.
//  Copyright © 2015 team[0]. All rights reserved.
//

import Foundation

class IOController {

    //Write settings to the plist file
    static func writeSettings(weight: Double?, gender: NSString?, emergencyNumber: NSString?, helpMessage: NSString?, includeLocation: Bool?, limit: Int?) {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)
        dict!.objectForKey("UserProfile")!.setObject(weight!, forKey: "weight")
        dict!.objectForKey("UserProfile")!.setObject(gender!, forKey: "gender")
        dict!.objectForKey("UserProfile")!.setObject(emergencyNumber!, forKey: "emergencyNumber")
        dict!.objectForKey("UserProfile")!.setObject(helpMessage!, forKey: "helpMessage")
        dict!.objectForKey("UserProfile")!.setObject(includeLocation!, forKey: "includeLocation")
        dict!.objectForKey("UserProfile")!.setObject(limit!, forKey: "limit")
        dict!.writeToFile(path!, atomically: false)
        print (path!)
        
    }
    
    //Set the first run property in the plist file
    static func setFirstRun(firstRun: Bool) {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)
        dict!.objectForKey("UserProfile")!.setObject(firstRun, forKey: "firstRun")
        dict!.writeToFile(path!, atomically: false)
    }
    
    
    //Get settings from the plist file
    //NOTE: This should only be used when initializing the settings class, all other access to settings should be done via an instance of the settings class
    static func getSettings() -> (weight: Double, gender: String, emergencyNumber: String, helpMessage: String, includeLocation: Bool, firstRun: Bool, limit: Int?){
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let userProfile = dict!.objectForKey("UserProfile") as! NSDictionary
        
        return ((userProfile.objectForKey("weight")?.doubleValue)!, (userProfile.objectForKey("gender") as! String?)!, (userProfile.objectForKey("emergencyNumber") as! String?)!, (userProfile.objectForKey("helpMessage") as! String?)!, (userProfile.objectForKey("includeLocation") as! Bool?)!, (userProfile.objectForKey("firstRun") as! Bool?)!, (userProfile.objectForKey("limit")?.integerValue)!)
        
    }

}


class Settings {
    var weight: Double?
    var gender: String?
    var emergencyNumber: String?
    var helpMessage: String?
    var includeLocation: Bool?
    var limit: Int?

    
    init(createDefault: Bool) {
        
        if createDefault {
            weight = 175.0
            gender = "Male"
            emergencyNumber = "5558675309"
            helpMessage = "I drank too much and I need help."
            includeLocation = true
            limit = 3
        } else {
            let settings = IOController.getSettings()
            self.weight = settings.weight
            self.gender = settings.gender
            self.emergencyNumber = settings.emergencyNumber
            self.helpMessage = settings.helpMessage
            self.includeLocation = settings.includeLocation
            self.limit = settings.limit
        }
    }
    
    
    
}

class ModelController {
    
    static func calculateBAC(totalDrinks: Double, ellapsedSeconds: Double) -> Double {
        
        
        let settings = Settings(createDefault: false)
        
        var const: Double?
        
        if settings.gender == "male" {
            const = 0.73
        } else if settings.gender == "female"{
            const = 0.66
        }
        
        let firstPart: Double! = (totalDrinks * 3084/1000)
        let secondPart: Double! = (settings.weight! * const!)
        let thirdPart: Double! = (15/1000 * ellapsedSeconds / 3600)
        let BAC: Double! = firstPart / secondPart - thirdPart
        
        return BAC
        
    }

}