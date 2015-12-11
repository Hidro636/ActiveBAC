//
//  WatchInterfaceController.swift
//  ActiveBAC
//
//  Created by Student 1 on 12/10/15.
//  Copyright © 2015 team[0]. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation


class WatchInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var bacLabel: WKInterfaceLabel!
    @IBAction func addDrinkButtonClick() {
        sendMessageToParentAppWithString("addDrink")
        print("added drink")
    }
    
    var session : WCSession?
    
    override init(){
        
        //  super class init
        super.init()
        
        //  if WCSession is supported
        if WCSession.isSupported() {    //  it is supported
            
            //  get default session
            session = WCSession.defaultSession()
            
            //  set delegate
            session!.delegate = self
            
            //  activate session
            session!.activateSession()
        } else {
            
            print("Watch does not support WCSession")
        }
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
    
    func sendMessageToParentAppWithString(messageText: String?) {
        let infoDictionary = ["message" : messageText as! AnyObject]
        if WCSession.defaultSession().reachable {
            print("sent: " + String(infoDictionary["message"]!))
            WCSession.defaultSession().sendMessage(infoDictionary, replyHandler: nil, errorHandler:  nil)
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        
        bacLabel.setText(String(Double(round(100*Double(message["message"]! as! NSNumber))/100)))
        
    }
    
}
