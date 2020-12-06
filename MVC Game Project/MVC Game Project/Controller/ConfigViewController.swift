

import UIKit

class ConfigViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    static var config : GameConfig!
    
    @IBOutlet weak var PlayerNameTextField: UITextField!
    
    @IBOutlet weak var CategoriePickerView: UIPickerView!
    
    @IBOutlet weak var LevelsSegmentedControl: UISegmentedControl!
    
    
    
    
     
    // PICKER VIEW
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Categories[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // SHOW AND HIDE PICKER VIEW
    
    @IBAction func CategorieOnOffSwitch(_ sender: UISwitch) {
        if sender.isOn == false {
            CategoriePickerView.isHidden = true
        } else {
            CategoriePickerView.isHidden = false
        }
    }
    
    //STEPPER
    @IBOutlet weak var NbrQuestionLabel: UILabel!
    
    @IBAction func NbrQuestionStepper(_ sender: UIStepper) {
         NbrQuestionLabel.text = "\(Int(sender.value))"
    }
    
    //Hide Keyboard

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        PlayerNameTextField.resignFirstResponder()
    }
    
    
    //VALIDATION
       @IBAction func validate(_ sender: Any) {
           createConfigObject()
           
           chekConfigStatus()
       }
        
    
    
    private func createConfigObject(){
     
        let PlayerName = PlayerNameTextField.text
        let LevelsIndex = LevelsSegmentedControl.selectedSegmentIndex
        let NumberOfQuestions = Int(NbrQuestionLabel.text!)
        
        
        switch LevelsIndex {
            
        case 0:
            GameViewController.config.Levels = "any"
        
        case 1:
            GameViewController.config.Levels = "easy"
            
        case 2:
            GameViewController.config.Levels = "medium"
            
        case 3 :
            GameViewController.config.Levels = "hard"
            
        default:
            break
        }
        
        let categoriesIndex = CategoriePickerView.selectedRow(inComponent: 0)
        
        switch categoriesIndex {
            
        case 0:
            GameViewController.config.Categories = 9
        case 1:
            GameViewController.config.Categories = 10
        case 2:
            GameViewController.config.Categories = 11
        case 3:
            GameViewController.config.Categories = 12
        case 4:
            GameViewController.config.Categories = 13
        default:
            break
        }
        
        
        
        GameViewController.config = GameConfig(PlayerName: PlayerName, NumberOfQuestions: NumberOfQuestions!, Levels: GameViewController.config.Levels , Categories:categoriesIndex)
          }
        
        private func chekConfigStatus() {
            
            switch GameViewController.config.status {
            case .accepted:
                  performSegue(withIdentifier: "segueToGameStart", sender: nil)
              case .rejected(let error):
                  presentAlert(with: error)
              }
            
    }
      
        
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Erreur", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segueToSuccess" {
                  let successVC = segue.destination as! StartViewController
                successVC.Config = GameViewController.config // On passe la donnée via les propriétés
              }
       }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

