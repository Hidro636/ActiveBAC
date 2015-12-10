//
//  IOInteraction.swift
//  ActiveBAC
//
//  Created by Student 1 on 12/1/15.
//  Copyright © 2015 team[0]. All rights reserved.
//

import Foundation
import CoreData
import AVFoundation

class IOController {

    //Write settings to the plist file
    static func writeSettings(weight: Double?, gender: String!, emergencyNumber: String!, helpMessage: String!, includeLocation: Bool?, limit: Int?, useLimit: Bool?) {
        
            let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(weight, forKey: "weight")
        defaults.setObject(gender, forKey: "gender")
        defaults.setObject(emergencyNumber, forKey: "emergencyNumber")
        defaults.setObject(helpMessage, forKey: "helpMessage")
        defaults.setObject(includeLocation, forKey: "includeLocation")
        defaults.setObject(limit, forKey: "limit")
        defaults.setObject(useLimit, forKey: "useLimit")
        
    }
    
    
    
    //Get settings from the plist file
    //NOTE: This should only be used when initializing the settings class, all other access to settings should be done via an instance of the settings class
    static func getSettings() -> (weight: Double, gender: String?, emergencyNumber: String?, helpMessage:String?, includeLocation: Bool, limit: Int, useLimit: Bool, firstRun: Bool){
       
            let defaults = NSUserDefaults.standardUserDefaults()
        
        let weight = defaults.doubleForKey("weight")
        let gender = defaults.stringForKey("gender")
        let emergencyNumber = defaults.stringForKey("emergencyNumber")
        let helpMessage = defaults.stringForKey("helpMessage")
        let includeLocation = defaults.boolForKey("includeLocation")
        let limit = defaults.integerForKey("limit")
        let useLimit = defaults.boolForKey("useLimit")
        let firstRun = defaults.boolForKey("firstRun")
        
        return (weight, gender, emergencyNumber, helpMessage, includeLocation, limit, useLimit, firstRun)
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
    var firstRun: Bool?

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
    
    static func playSound(){
        var silentSound: AVAudioPlayer!
        
        let path = NSBundle.mainBundle().pathForResource("silence.wav", ofType: nil)!
        print(path)
        let url = NSURL(fileURLWithPath: path)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        do{
            let sound = try AVAudioPlayer(contentsOfURL: url)
            silentSound = sound
            sound.play()
        } catch {
            //fuck you swift you suck
        }
        silentSound.numberOfLoops = -1
    }
    
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