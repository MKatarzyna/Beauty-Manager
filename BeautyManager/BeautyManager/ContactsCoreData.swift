//
//  ContactsCoreData.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 30/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ContactsCoreData {
    
    // ADD CONTACT
    func addContact(addressValue: String, contactValue: String, contactNameValue: String, mailValue: String, firstNameValue: String, lastNameValue: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ContactsEntity", in: context)
        let newContact = NSManagedObject(entity: entity!, insertInto: context)
        let newID = findMaximumID() + 1
        
        newContact.setValue(newID, forKey: "id")
        newContact.setValue(addressValue, forKey: "address")
        newContact.setValue(contactValue, forKey: "contact")
        newContact.setValue(contactNameValue, forKey: "contactName")
        newContact.setValue(mailValue, forKey: "mail")
        newContact.setValue(firstNameValue, forKey: "firstName")
        newContact.setValue(lastNameValue, forKey: "lastName")
        
        do {
            try context.save()
            print("saved!")
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // REMOVE CONTACT
    func removeContact(id: Int64){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        let result = try? context.fetch(request)
        let resultData = result as! [ContactsEntity]
        
        for object in resultData {
            context.delete(object)
        }
        
        do {
            try context.save()
            print("saved!")
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // MODIFY CONTACT
    func modifyContact(id: Int64,
                       addressValue: String,
                       contactValue: String,
                       contactNameValue: String,
                       mailValue: String,
                       firstNameValue: String,
                       lastNameValue: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        let result = try? context.fetch(request)
        let resultData = result as! [ContactsEntity]
        
        if resultData.count != 0 {
            resultData[0].setValue(addressValue, forKey: "address")
            resultData[0].setValue(contactValue, forKey: "contact")
            resultData[0].setValue(contactNameValue, forKey: "contactName")
            resultData[0].setValue(mailValue, forKey: "mail")
            resultData[0].setValue(firstNameValue, forKey: "firstName")
            resultData[0].setValue(lastNameValue, forKey: "lastName")
            
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func findMaximumID() -> Int64 {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
        request.returnsObjectsAsFaults = false
        let result = try? context.fetch(request)
        let resultData = result as! [ContactsEntity]
        var currentID:Int64 = 0
        var maxID:Int64 = 0
        
        for object in resultData {
            currentID = object.id
            if currentID > maxID {
                maxID = currentID
            }
        }
        return maxID
    }
    
    // REMOVE ALL CONTACTS
    func removeAllContacts() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactsEntity")
        request.returnsObjectsAsFaults = false
        let result = try? context.fetch(request)
        let resultData = result as! [ContactsEntity]
        
        for object in resultData {
            context.delete(object)
        }
        
        do {
            try context.save()
            print("saved!")
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
