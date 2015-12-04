import UIKit

class SettingsViewController: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var helpMessageTextBox: UITextView!
    @IBOutlet weak var emergencyNumberTextField: UITextField!
    @IBOutlet weak var weightTextBox: UITextField!
    @IBOutlet var gender: UISwitch!
    @IBOutlet weak var includeLocationSwitch: UISwitch!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var limitStepper: UIStepper!
    //@IBOutlet weak var limitStateSwitch: UISwitch!
    
    
    //Actions
    @IBAction func limitStepperChanged(sender: UIStepper) {
        limitLabel.text = String(Int(sender.value))
        
        
    }
    
    
    @IBAction func saveButtonClick(sender: UIButton) {
        let userWeight = (weightTextBox.text as NSString!).doubleValue
        var userGender: String?
        
        if(gender.on) {
            userGender = "female"
        } else {
            userGender = "male"
        }
        
        let emergencyNumber = emergencyNumberTextField.text
        
        let helpMessage = helpMessageTextBox.text
        let includeLocation = includeLocationSwitch.on
        //let limitState = limitStateSwitch.on
        
        IOController.writeSettings(userWeight, gender: userGender, emergencyNumber: emergencyNumber, helpMessage: helpMessage, includeLocation: includeLocation, limit: Int(limitLabel.text!))
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let settings = Settings(createDefault: false)
        
        weightTextBox.text = String(settings.weight!)
        emergencyNumberTextField.text = settings.emergencyNumber
        helpMessageTextBox.text = settings.helpMessage
        includeLocationSwitch.on  = settings.includeLocation!
        limitStepper.value = Double(settings.limit!)
        limitLabel.text = String(settings.limit!)
        
        
        
        if settings.gender == "male" {
            gender.on = false
        } else {
            gender.on = true
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func dismissKeyboard(){
    view.endEditing(true)
    }
}