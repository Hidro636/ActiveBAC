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
    @IBOutlet weak var useLimitSwitch: UISwitch!
    @IBOutlet weak var limitDescriptionLable: UILabel!
    
    
    //Actions
    
    //Change the limit label text to the value of the stepper
    @IBAction func limitStepperChanged(sender: UIStepper) {
        limitLabel.text = String(Int(sender.value))
    }
    
    //Enable and disable the limit control items when the "use limit" switch is changed
    @IBAction func useLimitSwitchChanged(sender: UISwitch) {
        if sender.on {
            limitStepper.enabled = true
            limitLabel.enabled = true
            limitDescriptionLable.enabled = true
        } else {
            limitStepper.enabled = false
            limitLabel.enabled = false
            limitDescriptionLable.enabled = false
        }
    }
    
    //Save and exit the view
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
        let useLimit = useLimitSwitch.on
        
        //Write all settings to the plist
        IOController.writeSettings(userWeight, gender: userGender, emergencyNumber: emergencyNumber, helpMessage: helpMessage, includeLocation: includeLocation, limit: Int(limitLabel.text!), useLimit: useLimit)
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
        
        useLimitSwitch.on = settings.useLimit!
        
        //Disable limit controls if the useLimit property is false
        if !settings.useLimit! {
            limitStepper.enabled = false
            limitLabel.enabled = false
            limitDescriptionLable.enabled = false
        }
        
        
        if settings.gender == "male" {
            gender.on = false
        } else {
            gender.on = true
        }
        
        //Hide keyboard on tap
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