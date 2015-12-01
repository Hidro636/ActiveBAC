import UIKit

class SettingsViewController: UIViewController {
    var userGender: String?
    var userWeight: Double?
    var phoneNumber: String?
    
    @IBOutlet weak var emergencyNumberTextField: UITextField!
    @IBOutlet var gender: UISwitch!
    @IBAction func genderSwitch(sender: AnyObject) {
        if gender.on {
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
        emergencyNumber = emergencyNumberTextField.text
        
        
        
        writeSettings(userWeight, gender: userGender, phoneNumber)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userGender = "female"
        userWeight = 0
        
        let settings = ioController.getSettings()
        self.userWeight = settings.weight
        self.userGender = settings.gender
        self.emergencyNumber = settings.emergencyNumber
        
        weight.text = String(userWeight!)
        emergencyNumberTextField.text = emergencyNumber
        
        if userGender! == "male" {
            gender.on = false
        }
    }
    
    func writeSettings(weight: Double?, gender: NSString?, number: NSString?) {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        let dict = NSMutableDictionary(contentsOfFile: path!)
        //saving values
        dict!.objectForKey("UserProfile")!.setObject(weight!, forKey: "weight")
        dict!.objectForKey("UserProfile")!.setObject(gender!, forKey: "gender")
        dict!.objectForKey("UserProfile")!.setObject(number!, forKey: "number")
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
        self.phoneNumber = (userProfile.objectForKey("number") as! String?)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}