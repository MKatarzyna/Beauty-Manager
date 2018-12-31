//
//  ReminderVC.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 31/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift
import PopupDialog

class ReminderVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var visitDate: String = ""
    var style = ToastStyle()
    var remindDate: String = ""
    var isReminderEnabled: Bool = false
    private var datePicker: UIDatePicker?
    

    
    @IBOutlet weak var visitDateTextField: UITextField!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var switchReminder: UISwitch!
    
    
    @IBAction func confirmReminder(_ sender: Any) {
        
        if (switchReminder.isOn == true) {
            if (reminderTextField.text != "") {
                isReminderEnabled = switchReminder.isOn
                performSegue(withIdentifier: "CloseReminderWindow", sender: self)
            } else {
                self.view.makeToast("Choose the date if you want turn ON reminder.", duration: 3.0, position: .bottom, style: style)
            }
        } else {
            isReminderEnabled = switchReminder.isOn
            performSegue(withIdentifier: "CloseReminderWindow", sender: self)
        }
    }
    
    func navigateToAppointmentView(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visitDateTextField.text = visitDate
        reminderTextField.text = remindDate
        switchReminder.isOn = isReminderEnabled
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(ReminderVC.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReminderVC.viewTapped(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        reminderTextField.inputView = datePicker
        
        self.hideKeyboardWhenTappedAround()
        
        // use this to hide keyboard while pressing return on keyboard
        self.reminderTextField.delegate = self
        self.visitDateTextField.delegate = self
    }
    
    // zabezpieczenie datePickera przed wklejaniem tresci i dodawaniem innych znaków niż te podane poprzez dataPicker
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == reminderTextField {
            return false
        }
        else {
            return true
        }
    }
    
    // handler method
    @objc func viewTapped(gestureRecognize: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        reminderTextField.text = dateFormatter.string(from: datePicker.date)
        remindDate = reminderTextField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
