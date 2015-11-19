import UIKit

class SettingsViewController: UIViewController {
    var userGender: String?
    var userWeight: Double?
    
    @IBOutlet var gender: UISwitch!
    @IBAction func genderSwitch(sender: AnyObject) {
        if gender.on{
            //change property list value
            print("on->off")
            userGender = "female"
            
        }
        else{
            //change property list value
            print("off->on")
            userGender = "male"
            
        }
    }
    @IBOutlet var weight: UITextField!
    
    @IBAction func saveButtonClick(sender: UIButton) {
        userWeight = (weight.text as NSString!).doubleValue
        
        print(userWeight)
        print(userGender)
        
        writeSettings(userWeight, gender: userGender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userGender = "female"
        userWeight = 0
        weight.text = "0"
    }
    
    func writeSettings(weight: Double?, gender: NSString?) {
        let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist")
        
        let dict = NSMutableDictionary(contentsOfFile: path!)
        
        //saving values
        dict!.objectForKey("UserProfile")!.setObject(weight!, forKey: "weight")
        dict!.objectForKey("UserProfile")!.setObject(gender!, forKey: "gender")
        //print(dict)
        //...
        //writing to GameData.plist
        dict!.writeToFile(path!, atomically: false)
        //let resultDictionary = NSMutableDictionary(contentsOfFile: path!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}