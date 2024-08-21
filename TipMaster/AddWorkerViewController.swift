//
//  AddWorkerViewController.swift
//  TipMaster
//
//  Created by ענבר צפר on 17/08/2024.
//

import UIKit

class AddWorkerViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet var nameField:UITextField!
    @IBOutlet weak var rolePicker: UIPickerView!
    @IBOutlet var startField:UITextField!
   
    
    var selectedRole = "Bartender" // Default role
      let roles = ["Bartender", "Waiter"] // Available roles
    
    public var completion:((String,String,String)-> Void)?
    
    private var timePicker: UIDatePicker?

    override func viewDidLoad() {
           super.viewDidLoad()
           
           // Initialize the timePicker and set it as input view for the startField
        timePicker = UIDatePicker()
               timePicker?.datePickerMode = .time
               timePicker?.locale = Locale(identifier: "en_GB") // This locale uses 24-hour format
                timePicker?.preferredDatePickerStyle = .wheels
        
        
        timePicker?.addTarget(self, action: #selector(didChangeTime), for: .valueChanged)
               
               startField.inputView = timePicker
               startField.delegate = self
        
        
        // Setup the toolbar with a Done button for the time picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
        toolbar.setItems([doneButton], animated: true)
        
        startField.inputAccessoryView = toolbar
        
           //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
           rolePicker.dataSource = self
           rolePicker.delegate = self
       }
       
       // Action triggered when the time picker value changes
    @objc func didChangeTime() {
           let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm" // 24-hour format
           startField.text = formatter.string(from: timePicker?.date ?? Date())
       }
    
    @objc func didTapDone() {
          startField.resignFirstResponder()
      }
    @IBAction func didTapSave() {
        // Check if the name field is empty
        if nameField.text?.isEmpty == true {
            showAlert(with: "Missing Information", message: "Please enter the worker's name.")
            return
        }
        
        // Check if the start time field is empty
        if startField.text?.isEmpty == true {
            showAlert(with: "Missing Information", message: "Please select the start time.")
            return
        }
        
        // Use the selected role
        let name = nameField.text!
        let time = startField.text!
        let role = selectedRole
        
        // Call the completion handler if it's set
        completion?(name, role, time)
        
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }

    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AddWorkerViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRole = roles[row]
    }
}
