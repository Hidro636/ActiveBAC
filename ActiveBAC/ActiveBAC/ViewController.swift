import UIKit

class ViewController: UIViewController {

    var time: NSTimer!
    var time1: NSTimer!
    @IBOutlet var LapsedTime: UILabel!
    @IBOutlet var BACLevel: UILabel!
    @IBOutlet var WarningMessage: UILabel!
    @IBOutlet var allDrinks: UILabel!
    var totalDrinks: Double! = 0
    var counter: Double! = 0
    var counter1 = 0
    var usersWeight: Double!
    var gender: Double!
    var usersGender: String!
    var totalDrinks1 = 0
    
    
    
    @IBAction func addDrinkButtonClick(sender: UIButton) {
        totalDrinks = totalDrinks + 1.0
        totalDrinks1 = totalDrinks1 + 1
        
        if (totalDrinks == 1){
            time = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "calculateBAC", userInfo: nil, repeats: true)
            time1 = NSTimer.scheduledTimerWithTimeInterval (1, target: self, selector: "clockTimer", userInfo: nil, repeats: true)
        }
        allDrinks.text = String(format:"%d", totalDrinks1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSettings()
    }
    
    func calculateBAC(){
        
        counter = counter + 1.0
        
        if usersGender == "male"{
        var firstPart: Double! = (totalDrinks * 3084/1000)
        var secondPart: Double! = (usersWeight * 0.73)
        var thirdPart: Double! = (15/1000 * counter / 3600)
        var BAC: Double! = firstPart / secondPart - thirdPart
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
            WarningMessage.text = "May need help standing, possible loss of memory, nauseau."
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.25 {
            WarningMessage.text = "Severe imparement!"
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.3 {
            WarningMessage.text = "Loss of conciousness!"
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.4 {
            WarningMessage.text = "Onset of come, possible death"
            WarningMessage.textColor = UIColor.redColor()
        }
            if BAC <= 0.0005{
                time.invalidate()
                time1.invalidate()
            }
    }else if usersGender == "female"{
            
            
        var firstPart: Double! = (totalDrinks * 3084/1000)
        var secondPart: Double! = (usersWeight * 0.66)
        var thirdPart: Double! = (15/1000 * counter / 3600)
        var BAC: Double! = firstPart / secondPart - thirdPart
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
            WarningMessage.text = "May need help standing, possible loss of memory, nauseau."
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.25 {
            WarningMessage.text = "Severe imparement!"
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.3 {
            WarningMessage.text = "Loss of conciousness!"
            WarningMessage.textColor = UIColor.redColor()
        } else if BAC < 0.4 {
            WarningMessage.text = "Onset of come, possible death"
            WarningMessage.textColor = UIColor.redColor()
        }
            if BAC <= 0.0005{
                time.invalidate()
                time1.invalidate()
            }
        }
    }
    
    
    func clockTimer() {
        counter1++
        var hours = counter1/3600
        var minutes = counter1/60 % 60
        var seconds = counter1 % 60
        LapsedTime.text = String(format: "%.02d:%.02d:%.02d", hours, minutes, seconds)
    }
    
    func getSettings() {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let userProfile = dict!.objectForKey("UserProfile") as! NSDictionary
        self.usersWeight = (userProfile.objectForKey("weight")?.doubleValue)!
        self.usersGender = (userProfile.objectForKey("gender") as! String?)!
        print(self.usersWeight)
        print(self.usersGender)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}




