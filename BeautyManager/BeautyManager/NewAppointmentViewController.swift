//
//  NewAppointmentViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 10/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData

class NewAppointmentViewController: UIViewController {
    var appointment: Appointment?
    let dateFormatter = DateFormatter()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBAction func addNewAppointment(_ sender: Any) {
        let nameValue = nameTextField.text
        let dateValue = dateTextField.text
        let contactValue = contactTextField.text
        let addressValue = addressTextField.text
        let notesValue = notesTextView.text
        if !(nameValue?.isEmpty)! && !(dateValue?.isEmpty)! && !(contactValue?.isEmpty)! && !(addressValue?.isEmpty)! && !(notesValue?.isEmpty)! {
            _ = CoreDataOperations().addAppointment(nameValue: nameTextField.text!, dateValue: dateTextField.text!, contactValue: contactTextField.text!, addressValue: addressTextField.text!, notesValue: notesTextView.text!)
            print("Appointment added")
            navigateToPreviousView()
        } else {
            print("Please populated all fields!")
        }
    }
    
    func navigateToPreviousView(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
