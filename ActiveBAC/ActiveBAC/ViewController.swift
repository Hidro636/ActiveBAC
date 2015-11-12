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
    var totalDrinks = 0
    
    @IBOutlet weak var ellapsedTimeLabel: UILabel!
    @IBOutlet weak var bacLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var limitProgressBar: UIProgressView!
    @IBOutlet weak var limitProgressLabel: UILabel!
    
    
    
    
    @IBAction func addDrinkButtonClicked(sender: UIButton) {
        if (totalDrinks == 0){
            time = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "calculateBAC", userInfo: nil, repeats: true)
        }
        totalDrinks = totalDrinks+1
    }
    @IBAction func menuButtonClicked(sender: UIButton) {
        //Unimplemented
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func calculateBAC(){
        //var BAC = (((totalDrinks * 0.60) * 5.14) / (usersWeight * usersGender )) - (0.015 * (LapsedTime/3600))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

