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
    static func writeSettings() {
       /* 
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        
        let dict = NSMutableDictionary(contentsOfFile: path!)
        dict!.objectForKey("UserProfile")!.setObject(weight!, forKey: "weight")
        dict!.objectForKey("UserProfile")!.setObject(gender!, forKey: "gender")
        dict!.objectForKey("UserProfile")!.setObject(emergencyNumber!, forKey: "emergencyNumber")
        dict!.objectForKey("UserProfile")!.setObject(helpMessage!, forKey: "helpMessage")
        dict!.objectForKey("UserProfile")!.setObject(includeLocation!, forKey: "includeLocation")
        dict!.objectForKey("UserProfile")!.setObject(limit!, forKey: "limit")
        dict!.writeToFile(path!, atomically: false)
        NSLog(path!)
*/
       /* let userData = PFObject(className: "UserData")
        userData["limit"] = limitLabel.text
       
        userData["helpMessage"] = helpMessageTextBox.text
        userData["emergencyNumber"] = emergencyNumberTextBox.text
        userData["weight"] = weightTextBox.text
        userData["gender"] = gender.text
        userData.pinInBackground()
        userData.saveInBackground()
        //userData["latitude"] =
        //userData["longitude"] =
        // userData["useLimit"] = settings.useLimit
       // userData["includeLocation"] = settings.includeLocation
*/
        
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
    static func getSettings() -> (){
        
       /* let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let userProfile = dict!.objectForKey("UserProfile") as! NSDictionary
        
        return ((userProfile.objectForKey("weight")?.doubleValue)!, (userProfile.objectForKey("gender") as! String?)!, (userProfile.objectForKey("emergencyNumber") as! String?)!, (userProfile.objectForKey("helpMessage") as! String?)!, (userProfile.objectForKey("includeLocation") as! Bool?)!, (userProfile.objectForKey("firstRun") as! Bool?)!, (userProfile.objectForKey("limit")?.integerValue)!,
            (userProfile.objectForKey("useLimit") as! Bool?)!)
*/
        let query = PFQuery(className: "UserData")
        query.fromLocalDatastore().orderByDescending("updatedAt")
        query.getFirstObjectInBackgroundWithBlock{
            (data: PFObject? , error: NSError?) -> Void in
            if error == nil {
               // print("successfully found \(data.count) users")
                print(data)
                
         //       if let data2 = data {
           //         for object in data2{
             //           print(object["weight"])
                  //  }
                //}
            }else{
                print("fuckSwift")
            }
        }
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
            /*let settings = IOController.getSettings()
            self.weight = settings.weight
            self.gender = settings.gender
            self.emergencyNumber = settings.emergencyNumber
            self.helpMessage = settings.helpMessage
            self.includeLocation = settings.includeLocation
            self.limit = settings.limit
            self.useLimit = settings.useLimit
*/
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