//
//  IOInteraction.swift
//  ActiveBAC
//
//  Created by Student 1 on 12/1/15.
//  Copyright © 2015 team[0]. All rights reserved.
//

import Foundation
import Parse

class IOController {

    //Write settings to the plist file
    static func writeSettings(weight: Double?, gender: String!, emergencyNumber: String!, helpMessage: String!, includeLocation: Bool?, limit: Int?, useLimit: Bool?) {
       
        
        let settings = PFObject(className: "settings")
        settings.objectId = "mainSettings"
        settings["weight"] = weight!
        settings["gender"] = gender
        settings["emergencyNumber"] = emergencyNumber!
        settings["helpMessage"] = helpMessage!
        settings["includeLocation"] = includeLocation!
        settings["limit"] = limit!
        settings["useLimit"] = useLimit!
        do {
            //try settings.pin()
            try PFObject.unpinAllObjects()
            try settings.pin()
        }
        catch {
            print("An error occurred while saving the user settings in the local datastore")
        }
        
        
    }
    
    //Set the first run property in the plist file
//    static func setFirstRun(firstRun: Bool) {
//        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
//        let dict = NSMutableDictionary(contentsOfFile: path!)
//        dict!.objectForKey("UserProfile")!.setObject(firstRun, forKey: "firstRun")
//        dict!.writeToFile(path!, atomically: false)
//    }
    
    
    //Get settings from the plist file
    //NOTE: This should only be used when initializing the settings class, all other access to settings should be done via an instance of the settings class
    static func getSettings() -> (Settings){
        
       /* let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let userProfile = dict!.objectForKey("UserProfile") as! NSDictionary
        
        return ((userProfile.objectForKey("weight")?.doubleValue)!, (userProfile.objectForKey("gender") as! String?)!, (userProfile.objectForKey("emergencyNumber") as! String?)!, (userProfile.objectForKey("helpMessage") as! String?)!, (userProfile.objectForKey("includeLocation") as! Bool?)!, (userProfile.objectForKey("firstRun") as! Bool?)!, (userProfile.objectForKey("limit")?.integerValue)!,
            (userProfile.objectForKey("useLimit") as! Bool?)!)
*/
        let query = PFQuery(className: "settings")
        query.fromLocalDatastore()
        
        var settings: PFObject?
        
        do {
            try settings = query.getObjectWithId("mainSettings")
        } catch {
            print("An error occurred getting settings from the local datastore")
        }
        
        let settingsObject = Settings(createDefault: true)
        
        if let settings = settings {
            settingsObject.weight = settings["weight"].doubleValue
            settingsObject.gender = String(settings["gender"])
            settingsObject.emergencyNumber = String(settings["emergencyNumber"])
            settingsObject.helpMessage = String(settings["helpMessage"])
            settingsObject.includeLocation = settings["includeLocation"].boolValue
            settingsObject.limit = settings["limit"].integerValue
            settingsObject.useLimit = settings["useLimit"].boolValue
        }
           //print("gender: " + String(settingsObject.gender))
        return settingsObject
    }
    
}


class Settings {
    var weight: Double?
    var gender: String?
    var emergencyNumber: String?
    var helpMessage: String?
    var includeLocation: Bool?
    var limit: Int?
    var useLimit: Bool?

    init() {
        
    }
    
    init(createDefault: Bool) {
        
        if createDefault {
            weight = 175.0
            gender = "Male"
            emergencyNumber = "5558675309"
            helpMessage = "I drank too much and I need help."
            includeLocation = true
            limit = 3
            useLimit = true
        } else {
            let settings = IOController.getSettings()
            self.weight = settings.weight
            self.gender = settings.gender
            self.emergencyNumber = settings.emergencyNumber
            self.helpMessage = settings.helpMessage
            self.includeLocation = settings.includeLocation
            self.limit = settings.limit
            self.useLimit = settings.useLimit

        }
    }
    
    
    
}

//This class allows for static data to be accessed from both the app view controllers and the watch interface
//The functions can be called with ModelData.<function>
//Ex. ModelData.incrementTotalDrinkgs()
class ModelData {
    static var totalDrinks: Double! = 0.0
    
    static func getTotalDrinks() -> Double {
        return totalDrinks
    }
    
    static func incrementTotalDrinks() {
        totalDrinks = totalDrinks + 1
    }
    
    static func resetTotalDrinks() {
        totalDrinks = 0
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