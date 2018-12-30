//
//  NewContactVC.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 30/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Toast_Swift

class NewContactVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var contact: Contact?
    var style = ToastStyle()
    
    let alphabetRule: CharacterSet = ["0","1","2","3","4","5","6","7","8","9", "a", "ą", "b", "c", "ć", "d", "e", "ę", "f", "g", "h", "i", "j", "k", "l", "ł", "m", "n", "ń", "o", "ó", "p", "q", "r", "s", "ś", "t", "u", "v", "w", "x", "y", "z", "ź", "ż", " ", "-"]

    
    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    // BUTTON ADD CONTACT
    @IBAction func createNewContact(_ sender: Any) {
        // red
        style.backgroundColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        style.messageColor = .white
        
        let finalSet = CharacterSet.letters.union(alphabetRule)
        
        if (contactNameTextField.text != "" && contactTextField.text != "") {
            if (finalSet.isSuperset(of: CharacterSet(charactersIn: contactNameTextField.text!)) == true) {
                _ = ContactsCoreData().addContact(addressValue: addressTextField.text!,
                                                  contactValue: contactTextField.text!,
                                                  contactNameValue: contactNameTextField.text!,
                                                  mailValue: mailTextField.text!,
                                                  firstNameValue: firstNameTextField.text!,
                                                  lastNameValue: lastNameTextField.text!)
                
                print("Contact added")
                navigateToContactsListView()
            } else {
                self.view.makeToast("Please ensure the name of contact field has correct characters (a-z, 0-9)", duration: 3.0, position: .bottom, style: style)
            }
        } else {
            self.view.makeToast("Please populate the name of contact and phone number fields!", duration: 3.0, position: .bottom, style: style)
        }
    }
    
    // powrót do poprzedniej strony
    func navigateToContactsListView(){
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewContactVC.viewTapped(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // handler method
    @objc func viewTapped(gestureRecognize: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // zakonczenie edycji textfieldów (zamkniecie klawiatury)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
