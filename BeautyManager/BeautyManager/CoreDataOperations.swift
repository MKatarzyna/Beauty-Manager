//
//  CoreDataOperations.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 10/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataOperations {
    let dateFormatter = DateFormatter()

    func addAppointment(nameValue: String, dateValue: String, contactValue: String, addressValue: String, notesValue: String, reminderValue: Bool, reminderDateValue: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AppointmentEntity", in: context)
        let newAppointment = NSManagedObject(entity: entity!, insertInto: context)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString = dateFormatter.date(from: dateValue)
        let reminderDateFromString = dateFormatter.date(from: reminderDateValue)
        
        let newID = findMaximumID() + 1
        print("NEW ID: \(newID)")
        
        newAppointment.setValue(nameValue, forKey: "name")
        newAppointment.setValue(dateFromString, forKey: "date")
        newAppointment.setValue(contactValue, forKey: "contact")
        newAppointment.setValue(addressValue, forKey: "address")
        newAppointment.setValue(notesValue, forKey: "notes")
        newAppointment.setValue(newID, forKey: "id")
        newAppointment.setValue(reminderValue, forKey: "reminder")
        newAppointment.setValue(reminderDateFromString, forKey: "reminderDate")
        
        do {
            try context.save()
            print("saved!")
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func removeAppointment(id: Int64){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        
        let result = try? context.fetch(request)
        let resultData = result as! [AppointmentEntity]
        
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
    
    func modifyAppointment(id: Int64, nameValue: String, dateValue: String, contactValue: String, addressValue: String, notesValue: String, reminderValue: Bool, reminderDateValue: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        
        let result = try? context.fetch(request)
        let resultData = result as! [AppointmentEntity]
        
        if resultData.count != 0{
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFromString = dateFormatter.date(from: dateValue)
            let reminderDateFromString = dateFormatter.date(from: reminderDateValue)
            
            resultData[0].setValue(nameValue, forKey: "name")
            resultData[0].setValue(dateFromString, forKey: "date")
            resultData[0].setValue(contactValue, forKey: "contact")
            resultData[0].setValue(addressValue, forKey: "address")
            resultData[0].setValue(notesValue, forKey: "notes")
            resultData[0].setValue(reminderValue, forKey: "reminder")
            resultData[0].setValue(reminderDateFromString, forKey: "reminderDate")
            
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let result = try? context.fetch(request)
        let resultData = result as! [AppointmentEntity]
        
        var currentID:Int64 = 0
        var maxID:Int64 = 0
        for object in resultData {
            currentID = object.id
            if currentID > maxID {
                maxID = currentID
            }
        }
        //print("MAX ID: \(maxID)")
        return maxID
    }
    
    // REMOVE ALL APPOINTMENTS
    func removeAllAppointments() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let result = try? context.fetch(request)
        let resultData = result as! [AppointmentEntity]
        
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
