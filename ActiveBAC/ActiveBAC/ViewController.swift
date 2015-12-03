import UIKit
import MessageUI
import CoreLocation

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, CLLocationManagerDelegate {

    var time: NSTimer!
    //var time1: NSTimer!
    var textPromptTimer: NSTimer!
    
    @IBOutlet var LapsedTime: UILabel!
    @IBOutlet var BACLevel: UILabel!
    @IBOutlet var WarningMessage: UILabel!
    @IBOutlet var allDrinks: UILabel!
    
    //@IBOutlet var MKMapView!
    
    var userBAC: Double!
    var totalDrinks: Double! = 0
    var counter: Double! = 0
    var counter1 = 0
    var textPromptCounter = 0
    var usersWeight: Double!
    var limit: Int!
    var gender: Double!
    var usersGender: String!
    var totalDrinks1 = 0
    var sendMessage = true
    let locationManager = CLLocationManager()
    
    @IBAction func addDrinkButtonClick(sender: UIButton) {
        if Int(totalDrinks) >= limit {
            showAlert("Over Limit", message: "You have exceeded the drink limit you defined in settings, be careful!")
            limitProgressView.progressTintColor = UIColor.redColor()
        }
        
        totalDrinks = totalDrinks + 1.0
        totalDrinks1 = totalDrinks1 + 1
        
        
        
        
        if (totalDrinks == 1){
            time = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "calculateBAC", userInfo: nil, repeats: true)
            //time1 = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "clockTimer", userInfo: nil, repeats: true)
        }
        allDrinks.text = String(format:"%d", totalDrinks1)
        
        self.limit = Settings(createDefault: false).limit
        limitProgressView.progress = Float(Double(totalDrinks) / Double(self.limit))

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = Settings(createDefault: false)
        self.usersWeight = settings.weight
        self.usersGender = settings.gender
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func calculateBAC(){
        
        //Added
        clockTimer()
        //-----------
        
        
        counter = counter + 1.0
        
        
        let BAC: Double! = ModelController.calculateBAC(totalDrinks, ellapsedSeconds: counter)
        
        
        userBAC = BAC
        BACLevel.text = String(format: "%.2f", BAC)
        
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
        
        if BAC <= 0.0005{
            time.invalidate()
            //time1.invalidate()
            totalDrinks = 0.0
            counter = 0.0
            counter1 = 0
            
            limitProgressView.progress = 0
            limitProgressView.progressTintColor = UIColor.whiteColor()
        }
        if BAC >= 0.2 {
            if sendMessage == true {
                //locationManager()
                sendForHelp()
                sendMessage = false
                textPromptTimer = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "checkEllapsedTime", userInfo: nil, repeats: true)
            }
        }
    }
    
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
    
    func clockTimer() {
        counter1++
        let hours = counter1/3600
        let minutes = counter1/60 % 60
        let seconds = counter1 % 60
        LapsedTime.text = String(format: "%.02d:%.02d:%.02d", hours, minutes, seconds)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    func sendForHelp(){
        if (MFMessageComposeViewController.canSendText()){
            
            let settings = Settings(createDefault: false)
            
            let controller = MFMessageComposeViewController()
            controller.body = settings.helpMessage
            controller.recipients = [settings.emergencyNumber!]
            
            //TODO: Add ability to attach location with text message
            
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
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromSettings(segue:UIStoryboardSegue){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}