//
//  AppointmentViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 27/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData

class AppointmentViewController: UIViewController {
    @IBOutlet weak var nameOfVisitTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    var appointment: Appointment?
    let dateFormatter = DateFormatter()
    var currentAppointmentID: Int64 = 0
    
    
    // przycisk usuwający jedną wizytę z DB
    @IBAction func removeAppointment(_ sender: Any) {
        
        CoreDataOperations().removeAppointment(
            id: currentAppointmentID,
            nameValue: nameOfVisitTextField.text!,
            dateValue: dateTextField.text!,
            contactValue: contactTextField.text!,
            addressValue: addressTextField.text!,
            notesValue: notesTextView.text!)
        
        print("Appointment removed")
        navigateToPreviousView()
    }
    
    // zapisanie zedytowanych pól w jednej wizycie w DB
    @IBAction func modifyAppointment(_ sender: Any) {
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
        }
        else {
            print("Please populate all fields!")
        }
    }
   
    func navigateToPreviousView(){
        navigationController?.popViewController(animated: true)
    }
    
    // wyświeltanie danych dla zaznaczonego wiersza
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfVisitTextField.text = appointment?.name
        dateTextField.text = appointment?.date
        contactTextField.text = appointment?.contact
        addressTextField.text = appointment?.address
        notesTextView.text = appointment?.notes
        currentAppointmentID = (appointment?.id)!
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
}
