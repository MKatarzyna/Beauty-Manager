//
//  EditContactVC.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 30/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift
import PopupDialog

class EditContactVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var contactNameTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    var style = ToastStyle()
    var contact: Contact?
    var currentContactID: Int64 = 0
    
    let alphabetRule: CharacterSet = ["0","1","2","3","4","5","6","7","8","9", "a", "ą", "b", "c", "ć", "d", "e", "ę", "f", "g", "h", "i", "j", "k", "l", "ł", "m", "n", "ń", "o", "ó", "p", "q", "r", "s", "ś", "t", "u", "v", "w", "x", "y", "z", "ź", "ż", " ", "-"]

    // powrót do poprzedniej strony
    func navigateToContactsListView(){
        navigationController?.popViewController(animated: true)
    }
    
    // USUWANIE KONTAKTU
    @IBAction func removeContact(_ sender: Any) {
        let mainTitle = "Removing contact"
        let question = "Do you want to remove this contact?"
        let popupDialog = PopupDialog(title: mainTitle, message: question)
        let cancelButton = CancelButton(title: "CANCEL") {
            print("You canceled the removing of contact.")
            self.view.makeToast("You canceled the removing of contact.", duration: 3.0, position: .bottom)
        }
        let yesButton = DefaultButton(title: "YES", dismissOnTap: true) {
            ContactsCoreData().removeContact(id: self.currentContactID)
            self.navigateToContactsListView()
        }
        popupDialog.addButtons([cancelButton, yesButton])
        self.present(popupDialog, animated: true, completion: nil)
    }
    
    // ZAPISANIE ZEDYTOWANYCH PÓL/kontaktu, nadpisanie go
    @IBAction func modifyContact(_ sender: Any) {
        // red
        style.backgroundColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        style.messageColor = .white
        let finalSet = CharacterSet.letters.union(alphabetRule)
        
        if (contactNameTextField.text != "" && contactTextField.text != "") {
            if (finalSet.isSuperset(of: CharacterSet(charactersIn: contactNameTextField.text!)) == true) {
                let mainTitle = "Modifying contact"
                let question = "Do you want to modify this contact?"
                let popupDialog = PopupDialog(title: mainTitle, message: question)
                
                let cancelButton = CancelButton(title: "CANCEL") {
                    print("You canceled the modifying of contact.")
                    self.view.makeToast("You canceled the modifying of contact.", duration: 3.0, position: .bottom)
                }
                
                let yesButton = DefaultButton(title: "YES", dismissOnTap: true) {
                    print("CurrentContactID: \(self.currentContactID)")
                    ContactsCoreData().modifyContact(id: self.currentContactID,
                                                     addressValue: self.addressTextField.text!,
                                                     contactValue: self.contactTextField.text!,
                                                     contactNameValue: self.contactNameTextField.text!,
                                                     mailValue: self.mailTextField.text!,
                                                     firstNameValue: self.firstNameTextField.text!,
                                                     lastNameValue: self.lastNameTextField.text!)
                    self.navigateToContactsListView()
                }
                
                popupDialog.addButtons([cancelButton, yesButton])
                self.present(popupDialog, animated: true, completion: nil)
            } else {
                self.view.makeToast("Please ensure the name of contact field has correct characters (a-z, 0-9)", duration: 3.0, position: .bottom, style: style)
            }
        } else {
            self.view.makeToast("Please populate the name of contact and phone number fields!", duration: 3.0, position: .bottom, style: style)
        }
    }

    // wyświeltanie danych dla zaznaczonego wiersza
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditContactVC.viewTapped(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        self.hideKeyboardWhenTappedAround()
        
        // use this to hide keyboard while pressing return on keyboard
        self.addressTextField.delegate = self
        self.contactTextField.delegate = self
        self.contactNameTextField.delegate = self
        self.mailTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        
        currentContactID = (contact?.id)!
        addressTextField.text = contact?.address
        contactTextField.text = contact?.contact
        contactNameTextField.text = contact?.contactName
        mailTextField.text = contact?.mail
        firstNameTextField.text = contact?.firstName
        lastNameTextField.text = contact?.lastName
    }
    
    @objc func viewTapped(gestureRecognize: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "te", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.center = nav!.center
        let image = UIImage(named: "Colorfull")
        imageView.image = image
        navigationItem.titleView = imageView
    } 
}
