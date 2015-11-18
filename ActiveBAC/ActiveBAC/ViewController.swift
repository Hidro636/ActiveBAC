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
    var time1: NSTimer!
    @IBOutlet var LapsedTime: UILabel!
    @IBOutlet var BACLevel: UILabel!
    @IBOutlet var WarningMessage: UILabel!
    var totalDrinks: Double! = 0
    var counter: Double! = 0
    var counter1 = 0
    var usersWeight: Double! = 150
    var gender: Double!
    var usersGender: String!
    
    
    @IBAction func DrinkAdded(sender: AnyObject) {
        totalDrinks = totalDrinks + 1.0
        
        if (totalDrinks == 1){
            time = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "calculateBAC", userInfo: nil, repeats: true)
            time1 = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "clockTimer", userInfo: nil, repeats: true)
        }
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func calculateBAC(){
        
        counter = counter + 1.0
        var firstPart: Double! = (totalDrinks * 3084/1000)
        var secondPart: Double! = (usersWeight * 0.73)
        var thirdPart: Double! = (15/1000 * counter / 3600)
        var BAC: Double! = firstPart / secondPart - thirdPart
        BACLevel.text = String(format: "%.2f", BAC)
    }
    
    func clockTimer() {
        
        counter1++
        var hours = counter1/3600
        var minutes = counter1/60 % 60
        var seconds = counter1 % 60
        LapsedTime.text = String(format: "%.02d:%.02d:%.02d", hours, minutes, seconds)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

