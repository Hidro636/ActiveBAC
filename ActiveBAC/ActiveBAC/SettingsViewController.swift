import UIKit

class SettingsViewController: UIViewController {
    var userGender: String?
    var userWeight: Double?
    var emergencyNumber: String?
    var ioController = IOController()
    
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
        
        
        ioController.writeSettings(userWeight, gender: userGender, emergencyNumber: emergencyNumber)
    
    
    func viewDidLoad() {
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
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}