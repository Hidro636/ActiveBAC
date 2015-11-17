//
//  SettingsView.swift
//  ActiveBAC
//
//  Created by Tommy Dillon on 11/17/15.
//  Copyright © 2015 team[0]. All rights reserved.
//

import UIKit

class SettingsView: UIViewController {

/*
outlet GenderSwitch
outlet WeightTextField
outlet GenderLabel
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("Property List", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }

        

    }
/*
action GenderSwitchHit{
    if GenderSwitch.on{
        GenderLabel.text = "Female"
        print("on->off")
        GenderSwitch.setOn(false, animated:true)
    }
        else{
            GenderLabel = "Male"
            print("off->on")
            GenderSwitch.setOn(true animated:true)
        }
    }
*/

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
