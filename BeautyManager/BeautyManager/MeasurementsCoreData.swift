//
//  MeasurementsCoreData.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 28/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MeasurementsCoreData {
    
    let dateFormatter = DateFormatter()
    
    func addMeasurement(resultBMIValue: Double, weightValue: Double, dateValue: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MeasurementsEntity", in: context)
        let newMeasurement = NSManagedObject(entity: entity!, insertInto: context)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = dateFormatter.date(from: dateValue)
        let newID = findMaximumID() + 1
        
        newMeasurement.setValue(newID, forKey: "id")
        newMeasurement.setValue(resultBMIValue, forKey: "resultBMI")
        newMeasurement.setValue(weightValue, forKey: "weight")
        newMeasurement.setValue(dateFromString, forKey: "date")
        
        do {
            try context.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func removeMeasurement(id: Int64){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MeasurementsEntity")
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        let result = try? context.fetch(request)
        let resultData = result as! [MeasurementsEntity]
        
        for object in resultData {
            context.delete(object)
        }
        
        do {
            try context.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func modifyMeasurement(id: Int64, resultBMIValue: Double, weightValue: Double, dateValue: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MeasurementsEntity")
        request.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        let result = try? context.fetch(request)
        let resultData = result as! [MeasurementsEntity]
        
        if resultData.count != 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFromString = dateFormatter.date(from: dateValue)
            resultData[0].setValue(resultBMIValue, forKey: "resultBMI")
            resultData[0].setValue(weightValue, forKey: "weight")
            resultData[0].setValue(dateFromString, forKey: "date")
            
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func findMaximumID() -> Int64 {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MeasurementsEntity")
        request.returnsObjectsAsFaults = false
        let result = try? context.fetch(request)
        let resultData = result as! [MeasurementsEntity]
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
    
    func removeAllMeasurements() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MeasurementsEntity")
        request.returnsObjectsAsFaults = false
        let result = try? context.fetch(request)
        let resultData = result as! [MeasurementsEntity]
        
        for object in resultData {
            context.delete(object)
        }
        
        do {
            try context.save()
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }    
}
