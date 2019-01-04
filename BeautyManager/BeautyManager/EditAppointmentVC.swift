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
import PopupDialog
import UserNotifications


class EditAppointmentVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var nameOfVisitTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var allDaySwitch: UISwitch!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var colorPickerControl: UISegmentedControl!
    
    private var datePicker: UIDatePicker?
    
    var style = ToastStyle()
    var appointment: Appointment?
    var phoneNumber: String = ""
    var remindDate: String = ""
    var isReminderEnabled: Bool = false
    
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    let alphabetRule: CharacterSet = ["0","1","2","3","4","5","6","7","8","9", "a", "ą", "b", "c", "ć", "d", "e", "ę", "f", "g", "h", "i", "j", "k", "l", "ł", "m", "n", "ń", "o", "ó", "p", "q", "r", "s", "ś", "t", "u", "v", "w", "x", "y", "z", "ź", "ż", " ", "-"]
    var currentAppointmentID: Int64 = 0
    
    // umożliwia wyłączenie okienka i przejście do poprzedniego poprzez segue. Odbiera zmienną phoneNumber z zamkniętego okienka
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.source is ContactsListVC {
            if let senderVC = unwindSegue.source as? ContactsListVC {
                phoneNumber = senderVC.phoneNumber
                contactTextField.text = phoneNumber
            }
        }
        if unwindSegue.source is ReminderVC {
            if let senderVC = unwindSegue.source as? ReminderVC {
                remindDate = senderVC.remindDate
                isReminderEnabled = senderVC.isReminderEnabled
            }
        }
    }
    
    @IBAction func sendSMS(_ sender: Any) {
        print("Enabled: \(isReminderEnabled), Remind Date: \(remindDate)")
        // POPUP DIALOG
        let mainTitle = "Sending SMS"
        let question = "Choose a template for SMS:"
        let popupDialog = PopupDialog(title: mainTitle, message: question)
        let cancelButton = CancelButton(title: "CANCEL") {
            self.view.makeToast("You canceled the sending a SMS.", duration: 3.0, position: .bottom)
        }
        let confirmSmsButton = DefaultButton(title: "Confirm a visit", dismissOnTap: true) {
            let sms: String = "sms:" + self.contactTextField.text! + "&body=Hello, I want to confirm my visit at " + self.dateTextField.text! + "."
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
//            self.navigateToPreviousView()
        }
        
        let cancelSmsButton = DefaultButton(title: "Cancel a visit", dismissOnTap: true) {
            let sms: String = "sms:" + self.contactTextField.text! + "&body=Hello, I want to cancel my visit at " + self.dateTextField.text! + "."
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
//            self.navigateToPreviousView()
        }
        
        let questionSmsButton = DefaultButton(title: "Book a visit", dismissOnTap: true) {
            let sms: String = "sms:" + self.contactTextField.text! + "&body=Hello, I want to book a visit at " + self.dateTextField.text! + ". Could you let me know, please?"
            let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
            //            self.navigateToPreviousView()
        }
        popupDialog.addButtons([cancelButton, confirmSmsButton, cancelSmsButton, questionSmsButton])
        self.present(popupDialog, animated: true, completion: nil)
    }
    
    // przycisk usuwający jedną wizytę z DB
    @IBAction func removeAppointment(_ sender: Any) {
        let mainTitle = "Removing appointment"
        let question = "Do you want to remove appointment?"
        let popupDialog = PopupDialog(title: mainTitle, message: question)
        let cancelButton = CancelButton(title: "CANCEL") {
            print("You canceled the removing of appointment.")
            self.view.makeToast("You canceled the removing of appointment.", duration: 3.0, position: .bottom)
        }
        let yesButton = DefaultButton(title: "YES", dismissOnTap: true) {
            self.turnOffReminder()
            CoreDataOperations().removeAppointment(
                id: self.currentAppointmentID)
            print("Appointment removed")
            self.navigateToPreviousView()
        }
        popupDialog.addButtons([cancelButton, yesButton])
        self.present(popupDialog, animated: true, completion: nil)
    }
    
    func turnOffReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["reminderID\(appointment?.id)"])
        print("OFF")
        print("reminderID\(appointment?.id)")
        
    }
    
    func turnOnReminder() {
        let content = UNMutableNotificationContent()
        content.title = (appointment?.name)!
        content.subtitle = (appointment?.date)!
        content.body = (appointment?.address)!
        content.badge = 1
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString = dateFormatter.date(from: remindDate)
        
        var date = DateComponents()
        date.year = calendar.component(.year, from: dateFromString!)
        date.day = calendar.component(.day, from: dateFromString!)
        date.month = calendar.component(.month, from: dateFromString!)
        date.hour = calendar.component(.hour, from: dateFromString!)
        date.minute = calendar.component(.minute, from: dateFromString!)

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "reminderID\(appointment?.id)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        print("ON")
        print("reminderID\(appointment?.id)")
    }
    
    
    // zapisanie zedytowanych pól w jednej wizycie w DB
    @IBAction func modifyAppointment(_ sender: Any) {
       
        // red
        style.backgroundColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        style.messageColor = .white
        
        let finalSet = CharacterSet.letters.union(alphabetRule)
        let numbersSet = CharacterSet.decimalDigits
        
        if (nameOfVisitTextField.text != "" && dateTextField.text != "" && remindDate != nil) {
            if (finalSet.isSuperset(of: CharacterSet(charactersIn: nameOfVisitTextField.text!)) == true) {
                if (numbersSet.isSuperset(of: CharacterSet(charactersIn: durationTextField.text!)) == true) {
                    let mainTitle = "Modifying appointment"
                    let question = "Do you want to modify appointment?"
                    let popupDialog = PopupDialog(title: mainTitle, message: question)
                
                    let cancelButton = CancelButton(title: "CANCEL") {
                        print("You canceled the modifying of appointment.")
                        self.view.makeToast("You canceled the modifying of appointment.", duration: 3.0, position: .bottom)
                    }
                
                    let yesButton = DefaultButton(title: "YES", dismissOnTap: true) {
                        CoreDataOperations().modifyAppointment(
                            id: self.currentAppointmentID,
                            nameValue: self.nameOfVisitTextField.text!,
                            dateValue: self.dateTextField.text!,
                            contactValue: self.contactTextField.text!,
                            addressValue: self.addressTextField.text!,
                            notesValue: self.notesTextView.text!,
                            reminderValue: self.isReminderEnabled,
                            reminderDateValue: self.remindDate,
                            durationValue: self.durationTextField.text!,
                            colorNumberValue: Int64(self.colorPickerControl!.selectedSegmentIndex),
                            isAllDayValue: self.allDaySwitch.isOn)
                        
                        print("RemindDate: \(self.remindDate)")
                        
                        if (self.isReminderEnabled == true) {
                            self.turnOnReminder()
                        } else {
                            self.turnOffReminder()
                        }
                        
                        print("Appointment modified")
                        self.navigateToPreviousView()
                    }

                    popupDialog.addButtons([cancelButton, yesButton])
                    self.present(popupDialog, animated: true, completion: nil)
                } else {
                    self.view.makeToast("Please ensure the duration field has correct characters (0-9)", duration: 3.0, position: .bottom, style: style)
                }
            } else {
                self.view.makeToast("Please ensure the name field has correct characters (a-z, 0-9)", duration: 3.0, position: .bottom, style: style)
            }
        } else {
            self.view.makeToast("Please populate all fields!", duration: 3.0, position: .bottom, style: style)
        }
    }
   
    func navigateToPreviousView(){
        navigationController?.popViewController(animated: true)
    }
    
    // wyświeltanie danych dla zaznaczonego wiersza
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(EditAppointmentVC.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditAppointmentVC.viewTapped(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        dateTextField.inputView = datePicker
        
        self.hideKeyboardWhenTappedAround()
        
        // use this to hide keyboard while pressing return on keyboard
        self.nameOfVisitTextField.delegate = self
        self.dateTextField.delegate = self
        self.contactTextField.delegate = self
        self.addressTextField.delegate = self
        self.notesTextView.delegate = self
        self.durationTextField.delegate = self
        
        print(appointment)
        print("COLOR: \(appointment?.colorNumber)")
        print("DURATIION: \(appointment?.duration)")
        print("DURATIION S: \(String(describing: appointment?.duration))")
        
        (colorPickerControl.subviews[0] as UIView).tintColor = UIColor.blue
        (colorPickerControl.subviews[1] as UIView).tintColor = UIColor.yellow
        (colorPickerControl.subviews[2] as UIView).tintColor = UIColor.green
        (colorPickerControl.subviews[3] as UIView).tintColor = UIColor.red
        (colorPickerControl.subviews[4] as UIView).tintColor = UIColor.orange
        (colorPickerControl.subviews[5] as UIView).tintColor = UIColor.magenta
        
        nameOfVisitTextField.text = appointment?.name
        dateTextField.text = appointment?.date
        contactTextField.text = appointment?.contact
        addressTextField.text = appointment?.address
        notesTextView.text = appointment?.notes
        currentAppointmentID = (appointment?.id)!
        isReminderEnabled = (appointment?.reminder)!
        remindDate = (appointment?.reminderDate)!
        durationTextField.text = appointment?.duration
        colorPickerControl.selectedSegmentIndex = Int((appointment?.colorNumber)!)
        allDaySwitch.isOn = (appointment?.isAllDay)!
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
       
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        remindDate = dateTextField.text!
        isReminderEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // wysłanie elementu z tablicy contacts dla zaznaczonego wiersza
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ReminderVC {
            destination.visitDate = dateTextField.text!
            destination.remindDate = remindDate
            destination.isReminderEnabled = isReminderEnabled
        }
    }
}
