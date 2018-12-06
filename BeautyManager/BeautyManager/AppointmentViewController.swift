//
//  AppointmentViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 27/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift

//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

class AppointmentViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var nameOfVisitTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    private var datePicker: UIDatePicker?
    
    var style = ToastStyle()
    var appointment: Appointment?
    
    let dateFormatter = DateFormatter()
    let alphabetRule: CharacterSet = ["0","1","2","3","4","5","6","7","8","9", "a", "ą", "b", "c", "ć", "d", "e", "ę", "f", "g", "h", "i", "j", "k", "l", "ł", "m", "n", "ń", "o", "ó", "p", "q", "r", "s", "ś", "t", "u", "v", "w", "x", "y", "z", "ź", "ż", " ", "-"]
    var currentAppointmentID: Int64 = 0
    
    @IBAction func sendSMS(_ sender: Any)
    {
        let sms: String = "sms:"+contactTextField.text!+"&body=Hello, I want to confirm my visit at "+dateTextField.text!+"."
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    
    
    // przycisk usuwający jedną wizytę z DB
    @IBAction func removeAppointment(_ sender: Any) {
        
        CoreDataOperations().removeAppointment(
            id: currentAppointmentID)
        
        print("Appointment removed")
        navigateToPreviousView()
    }
    
    // zapisanie zedytowanych pól w jednej wizycie w DB
    @IBAction func modifyAppointment(_ sender: Any) {
        
        // red
        style.backgroundColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        style.messageColor = .white
        
        let finalSet = CharacterSet.letters.union(alphabetRule)
        
        
        if (nameOfVisitTextField.text != "" && dateTextField.text != "") {
            if (finalSet.isSuperset(of: CharacterSet(charactersIn: nameOfVisitTextField.text!)) == true) {
                
                let nameValue = nameOfVisitTextField.text
                let dateValue = dateTextField.text
                let contactValue = contactTextField.text
                let addressValue = addressTextField.text
                let notesValue = notesTextView.text
                
                if !(nameValue?.isEmpty)! &&
                    !(dateValue?.isEmpty)! &&
                    !(contactValue?.isEmpty)! &&
                    !(addressValue?.isEmpty)! &&
                    !(notesValue?.isEmpty)! {
                    
                    CoreDataOperations().modifyAppointment(
                        id: currentAppointmentID,
                        nameValue: nameOfVisitTextField.text!,
                        dateValue: dateTextField.text!,
                        contactValue: contactTextField.text!,
                        addressValue: addressTextField.text!,
                        notesValue: notesTextView.text!)
                    
                    print("Appointment modified")
                    navigateToPreviousView()
                } else {
                    print("Please populate all fields!")
                }
            } else {
                self.view.makeToast("Please ensure the name field has correct characters (a-z, 0-9)", duration: 3.0, position: .bottom, style: style)
            }
        } else {
            self.view.makeToast("Please populate name and date fields!", duration: 3.0, position: .bottom, style: style)
        }
    }
   
    func navigateToPreviousView(){
        navigationController?.popViewController(animated: true)
    }
    
    // wyświeltanie danych dla zaznaczonego wiersza
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(AppointmentViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AppointmentViewController.viewTapped(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        dateTextField.inputView = datePicker
        
        self.hideKeyboardWhenTappedAround()
        
        // use this to hide keyboard while pressing return on keyboard
        self.nameOfVisitTextField.delegate = self
        self.dateTextField.delegate = self
        self.contactTextField.delegate = self
        self.addressTextField.delegate = self
        self.notesTextView.delegate = self
        
        nameOfVisitTextField.text = appointment?.name
        dateTextField.text = appointment?.date
        contactTextField.text = appointment?.contact
        addressTextField.text = appointment?.address
        notesTextView.text = appointment?.notes
        currentAppointmentID = (appointment?.id)!
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
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
