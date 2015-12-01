import UIKit

class SettingsViewController: UIViewController {
    var userGender: String?
    var userWeight: Double?
    
    @IBOutlet var gender: UISwitch!
    @IBAction func genderSwitch(sender: AnyObject) {
        if gender.on{
            print("left to right")
            userGender = "female"
            
        }
        else {
            print("right to left")
            userGender = "male"
            
        }
    }
    @IBOutlet var weight: UITextField!
    
    @IBAction func saveButtonClick(sender: UIButton) {
        userWeight = (weight.text as NSString!).doubleValue
        
        
        
        writeSettings(userWeight, gender: userGender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userGender = "female"
        userWeight = 0
        
        getSettings()
        
        weight.text = String(userWeight!)
        
        if userGender! == "male" {
            gender.on = false
        }
    }
    
    func writeSettings(weight: Double?, gender: NSString?) {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)
        //saving values
        dict!.objectForKey("UserProfile")!.setObject(weight!, forKey: "weight")
        dict!.objectForKey("UserProfile")!.setObject(gender!, forKey: "gender")
        //writing to GameData.plist
        dict!.writeToFile(path!, atomically: false)
        //let resultDictionary = NSMutableDictionary(contentsOfFile: path!)
    }
    
    func getSettings() {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let userProfile = dict!.objectForKey("UserProfile") as! NSDictionary
        self.userWeight = (userProfile.objectForKey("weight")?.doubleValue)!
        self.userGender = (userProfile.objectForKey("gender") as! String?)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}