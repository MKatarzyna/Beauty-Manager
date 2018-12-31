//
//  ContactsListVC.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 30/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContactsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var selectContact: UIBarButtonItem!
    @IBOutlet weak var editContact: UIBarButtonItem!
    
    // na pasku navigacyjnym -> przenosi do edycji
    @IBAction func editContact(_ sender: Any) {
        performSegue(withIdentifier: "showContactDetails", sender: self)
    }
    // na pasku nawigacyjnym przycisk DONE
    @IBAction func selectContact(_ sender: Any) {
        phoneNumber = contactsArray[selectedRow].contact
        print(phoneNumber)
        performSegue(withIdentifier: "CloseContactsList", sender: self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactsArray = [Contact]()
    var selectedRow: Int = -1
    var phoneNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // na starcie nie można ich użyć, są wyłączone
        editContact.isEnabled = false
        selectContact.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contactsArray.removeAll()
        loadContactsDataFromDB()
        tableView.reloadData()
        editContact.isEnabled = false
        selectContact.isEnabled = false
    }
    
    // wczytanie danych z core data
    @objc func loadContactsDataFromDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
        request.returnsObjectsAsFaults = false
        
        // pobranie wszystkich wartości atrybutów z encji
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let idValue = data.value(forKey: "id") as! Int64
                let addressValue = data.value(forKey: "address") as! String
                let contactValue = data.value(forKey: "contact") as! String
                let contactNameValue = data.value(forKey: "contactName") as! String
                let mailValue = data.value(forKey: "mail") as! String
                let firstNameValue = data.value(forKey: "firstName") as! String
                let lastNameValue = data.value(forKey: "lastName") as! String
                
                print("ID value: \(idValue)")
                
               // umieszczenie wartości w obiekcie contacts
                let contact = Contact(
                    id: idValue,
                    address: addressValue,
                    contact: contactValue,
                    contactName: contactNameValue,
                    mail: mailValue,
                    firstName: firstNameValue,
                    lastName: lastNameValue)
                // dodanie jednego kontaktu do tablicy kontaktów (do listy)
                contactsArray.append(contact)
            }
        } catch {
            print("Failed")
        }
    }
    
    // zliczenie elementów z tablicy, aby tableview wiedział ile wierszy ma wyświetlić
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsArray.count
    }
    
    //wyświetlanie wartości na liście, z duzej litery (capitalize)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        cell?.textLabel?.text = contactsArray[indexPath.row].contactName.capitalized
        return cell!
    }
    
    
    // jesli wiersz został zaznaczony/klikniety to wykonaj przejscie (segue) o nazwie showContactDetails
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        editContact.isEnabled = true
        selectContact.isEnabled = true
        selectedRow = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("SELECT")
    }

    // wysłanie elementu z tablicy contacts dla zaznaczonego wiersza
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditContactVC {
            destination.contact = contactsArray[(tableView.indexPathForSelectedRow?.row)!]
        }
    } 
}
