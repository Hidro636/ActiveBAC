import UIKit
import MessageUI
import CoreLocation
import Social
import AVFoundation

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {
    
    var time: NSTimer!
    var timeSound: NSTimer!
    var textPromptTimer: NSTimer!
    
    @IBOutlet var LapsedTime: UILabel!
    @IBOutlet var BACLevel: UILabel!
    @IBOutlet var WarningMessage: UILabel!
    @IBOutlet var allDrinks: UILabel!
    @IBOutlet var limitProgressView: UIProgressView!
    
    var userBAC: Double!
    var counter: Double! = 0
    var counter1 = 0
    var textPromptCounter = 0
    var usersWeight: Double!
    var limit: Int!
    var gender: Double!
    var usersGender: String!
    var sendMessage = true
    var currentLat: String!
    var currentLong: String!
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBAction func addDrinkButtonClick(sender: UIButton) {
        
        let settings = Settings(createDefault: false)
        if settings.useLimit! {
        }
        //Check to see if the user is using a limit
        if settings.useLimit! {
            
            //Check to see if the current total drink count is greater than the set limit, and display a message if it is
            if Int(totalDrinks()) >= limit {
                showAlert("Over Limit", message: "You have exceeded the drink limit you defined in settings, be careful!")
                limitProgressView.progressTintColor = UIColor.redColor()
            }
        }
        
        //Increment the total drink count
        ModelData.incrementTotalDrinks()
        
        
        //Start the timer when the user first adds a drink
            if (self.totalDrinks() == 1){
                UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler(nil)
            self.time = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "calculateBAC", userInfo: nil, repeats: true)
                NSRunLoop.currentRunLoop().addTimer(self.time, forMode: NSRunLoopCommonModes)
            }
    
        //Display total drinks on a label
        allDrinks.text = String(Int(totalDrinks()))
        
        //Check to see if the user is using a limit
        if settings.useLimit! {
            
            //Set the progress of the limit progress bar
            self.limit = settings.limit
            limitProgressView.progress = Float(Double(totalDrinks()) / Double(self.limit))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModelController.playSound()
        
        //Load settings
        let settings = Settings(createDefault: false)
        self.usersWeight = settings.weight
        self.usersGender = settings.gender
        self.limit = settings.limit
        
        //set the limit of the limit progress bar IF the user has set a limit
       /* if settings.useLimit!{
        
            limitProgressView.progress = Float(Double(totalDrinks()) / Double(self.limit))
        }
*/
        
        //Initialize location manager for use in emergency texts
        locationManager = CLLocationManager()
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //Asks for authorization from user
        self.locationManager.requestAlwaysAuthorization()
        
        //used in the Foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
   UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    func calculateBAC(){
        
        //Increment the clock
        clockTimer()
        
        //Increment counter
        counter = counter + 1.0
        
        //Calculate user BAC
        let BAC: Double! = ModelController.calculateBAC(totalDrinks(), ellapsedSeconds: counter)
        
        //set local property to user BAC
        userBAC = BAC
        
        //Display user BAC on a label
        BACLevel.text = String(format: "%.2f", BAC)
        
        
        //Change message to reflect current user BAC
        if BAC <= 0.0005 {
            WarningMessage.text = "You are not impaired, have a good night!"
            WarningMessage.textColor = UIColor.greenColor()
        } else if BAC < 0.03 {
            WarningMessage.text = "Slight euphoria, mild relaxation."
            WarningMessage.textColor = UIColor.greenColor()
        } else if BAC < 0.06 {
            WarningMessage.text = "Feeling of wellbeing, lower inhibitions."
            WarningMessage.textColor = UIColor.yellowColor()
        } else if BAC < 0.09 {
            WarningMessage.text = "Some imparement, reduced judgement."
            WarningMessage.textColor = UIColor.yellowColor()
        } else if BAC < 0.12 {
            WarningMessage.text = "Loss of judgement, significant imparement!"
            WarningMessage.textColor = UIColor.orangeColor()
        } else if BAC < 0.19 {
            WarningMessage.text = "Dysphoria, confusion, possible nauseau."
            WarningMessage.textColor = UIColor.orangeColor()
        } else if BAC < 0.20 {
            WarningMessage.text = "Loss of memory, nauseau."
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.25 {
            WarningMessage.text = "Severe imparement!"
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.3 {
            WarningMessage.text = "Loss of conciousness!"
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.4 {
            WarningMessage.text = "Onset of coma, possible death"
            WarningMessage.textColor = UIColor.redColor()
        }
        
        //Check to see if the user BAC is below an insignificant level, and reset counters/timers if it is
        if BAC <= 0.0005{
            time.invalidate()
            //time1.invalidate()
            ModelData.resetTotalDrinks()
            counter = 0.0
            counter1 = 0
            
            limitProgressView.progress = 0
            limitProgressView.progressTintColor = UIColor.whiteColor()
        }
        
        //Check to see if the user's BAC is dangerously high, and ask to send an emergency text if it is
        if BAC >= 0.2 {
            if sendMessage == true {
                
                showMessageAlert("Send For Help?", message: "Would you like us to send your location to your emergency contact?")
                
                self.sendMessage = false
                textPromptTimer = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "checkEllapsedTime", userInfo: nil, repeats: true)
            }
        }
    }
    
    //Check time for emergency text message reminder
    func checkEllapsedTime() {
        textPromptCounter++
        
        if userBAC < 0.19 {
            textPromptTimer.invalidate()
            textPromptCounter = 0
        }
        
        if textPromptCounter / 60 % 60 == 30 {
            sendMessage = true
        }
    }
    
    //Increment timer counters and display ellapsed time on a label
    func clockTimer() {
        counter1++
        let hours = counter1/3600
        let minutes = counter1/60 % 60
        let seconds = counter1 % 60
        LapsedTime.text = String(format: "%.02d:%.02d:%.02d", hours, minutes, seconds)
    }
    
    //Function is automatically called by locationManager, gets the user location and stores it in local properties
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation: AnyObject = locations[0]
        currentLat = String(latestLocation.coordinate.latitude)
        currentLong = String(latestLocation.coordinate.longitude)
        print("Lat: " + currentLat + ", Long: " + currentLong)
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        
    }
    
    //Function that generates an emergency text message and attaches a location if the user has specified so
    func sendForHelp(){
        if (MFMessageComposeViewController.canSendText()){
            
            let settings = Settings(createDefault: false)
            
            let controller = MFMessageComposeViewController()
            controller.body = settings.helpMessage
            controller.recipients = [settings.emergencyNumber!]
            
            //If using location, specifiy latitude and longitude as a map link
            if settings.includeLocation! {
                controller.body = controller.body! + "\nLocation:  + http://maps.apple.com/?q=Help&ll=" + currentLat + "," + currentLong

            }
            
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    //Confirm that the user wants to send an emergency text message
    func showMessageAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: {(action: UIAlertAction!) in
            self.sendForHelp()
            
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        if self.presentedViewController != nil{
            self.dismissViewControllerAnimated(false, completion: nil)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //Display a simple alert to the user
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        
        if self.presentedViewController != nil{
            self.dismissViewControllerAnimated(false, completion: nil)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //shorthand function for retrieving the total drink count
    func totalDrinks() -> Double {
        return ModelData.getTotalDrinks()
    }
    
    
    @IBAction func unwindFromSettings(segue:UIStoryboardSegue){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}