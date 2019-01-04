//
//  NewAppointmentViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 10/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift

class NewAppointmentVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var appointment: Appointment?
    var style = ToastStyle()
    var phoneNumber: String = ""
    var remindDate: String = ""
    var isReminderEnabled: Bool = false
    
    let dateFormatter = DateFormatter()
    let alphabetRule: CharacterSet = ["0","1","2","3","4","5","6","7","8","9", "a", "ą", "b", "c", "ć", "d", "e", "ę", "f", "g", "h", "i", "j", "k", "l", "ł", "m", "n", "ń", "o", "ó", "p", "q", "r", "s", "ś", "t", "u", "v", "w", "x", "y", "z", "ź", "ż", " ", "-"]

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    private var datePicker: UIDatePicker?
    
    // umożliwia wyłączenie okienka i przejście do poprzedniego poprzez segue. Odbiera zmienną phoneNumber z zamkniętego okienka
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is ContactsListVC {
            if let senderVC = unwindSegue.source as? ContactsListVC {
                phoneNumber = senderVC.phoneNumber
                contactTextField.text = phoneNumber
            }
        }
    }
    
    @IBAction func addNewAppointment(_ sender: Any) {
        
        // red
        style.backgroundColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        style.messageColor = .white
        
        let finalSet = CharacterSet.letters.union(alphabetRule)
        
        if (nameTextField.text != "" && dateTextField.text != "") {
            if (finalSet.isSuperset(of: CharacterSet(charactersIn: nameTextField.text!)) == true) {
                    _ = CoreDataOperations().addAppointment(nameValue: nameTextField.text!,
                                                            dateValue: dateTextField.text!,
                                                            contactValue: contactTextField.text!,
                                                            addressValue: addressTextField.text!,
                                                            notesValue: notesTextView.text!,
                                                            reminderValue: isReminderEnabled,
                                                            reminderDateValue: remindDate,
                                                            durationValue: "60",
                                                            colorNumberValue: 0,
                                                            isAllDayValue: false)
                
                print("Appointment added")
                navigateToPreviousView()
            } else {
                self.view.makeToast("Please ensure the name field has correct characters (a-z, 0-9)", duration: 3.0, position: .bottom, style: style)
            }
        } else {
            self.view.makeToast("Please populate name and date fields!", duration: 3.0, position: .bottom, style: style)
        }
    }
    
    // BACK TO PREVIOUS PAGE
    func navigateToPreviousView() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(NewAppointmentVC.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewAppointmentVC.viewTapped(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        dateTextField.inputView = datePicker
        
        self.hideKeyboardWhenTappedAround()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        remindDate = dateFormatter.string(from: Date())
    }
    
    // zabezpieczenie datePickera przed wklejaniem tresci i dodawaniem innych znaków niż te podane poprzez dataPicker
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == dateTextField {
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //  HH:mm:ss
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
