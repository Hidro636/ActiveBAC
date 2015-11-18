import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var gender: UISwitch!
    @IBAction func genderSwitch(sender: AnyObject) {
        if gender.on{
            //change property list value
            print("on->off")
            gender.setOn(false, animated:true)
        }
        else{
            //change property list value
            print("off->on")
            gender.setOn(true, animated:true)
        }
    }
    @IBOutlet var weight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var SavedUserData: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("UserData", ofType: "plist") {
            SavedUserData = NSDictionary(contentsOfFile: path)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}