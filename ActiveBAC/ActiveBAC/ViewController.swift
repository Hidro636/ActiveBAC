//
//  ViewController.swift
//  ActiveBAC
//
//  Created by liblabs-mac on 10/14/15.
//  Copyright (c) 2015 team[0]. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var time: NSTimer!
    @IBOutlet var LapsedTime: UILabel!
    @IBOutlet var BACLevel: UILabel!
    @IBOutlet var WarningMessage: UILabel!
    var totalDrinks = 0
    var counter = 0
    
    
    @IBAction func DrinkAdded(sender: AnyObject) {
        if (totalDrinks == 0){
            time = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "calculateBAC", userInfo: nil, repeats: true)
        }
        totalDrinks = totalDrinks+1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func calculateBAC(){
        var BAC = (((totalDrinks * 0.60) * 5.14) / (usersWeight * usersGender )) - (0.015 * (LapsedTime/3600))
        counter++
        var hours = (counter/3600)
        var minutes = (counter/60) % 60
        var seconds = counter % 60
        BACLevel.text = String (BAC)
        LapsedTime.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

