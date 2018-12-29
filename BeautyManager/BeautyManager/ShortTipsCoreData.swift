//
//  ShortTipsCoreData.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 29/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShortTipsCoreData {
    let dateFormatter = DateFormatter()
    
    // ADD
    func addShortTip(shortTipValue: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ShortTipEntity", in: context)
        let newShortTip = NSManagedObject(entity: entity!, insertInto: context)
        
        let newID = findMaximumID() + 1
        print("NEW ID: \(newID)")
        
        newShortTip.setValue(newID, forKey: "id")
        newShortTip.setValue(shortTipValue, forKey: "shortTip")
        
        do {
            try context.save()
            print("saved!")
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    // REMOVE
    func removeShortTip(id: Int64){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShortTipEntity")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        
        let result = try? context.fetch(request)
        let resultData = result as! [ShortTipEntity]
        
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
    
    // MODIFY
    func modifyTip(id: Int64, shortTipValue: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShortTipEntity")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "id == \(id)")
        request.predicate = predicate
        
        let result = try? context.fetch(request)
        let resultData = result as! [ShortTipEntity]
        
        if resultData.count != 0 {
            
            resultData[0].setValue(shortTipValue, forKey: "shortTip")
            
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    // FIND MAX ID
    func findMaximumID() -> Int64 {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShortTipEntity")
        request.returnsObjectsAsFaults = false
        
        let result = try? context.fetch(request)
        let resultData = result as! [ShortTipEntity]
        
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
    
    // REMOVE ALL SHORT TIPS
    func removeAllShortTips() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShortTipEntity")
        request.returnsObjectsAsFaults = false
        
        let result = try? context.fetch(request)
        let resultData = result as! [ShortTipEntity]
        
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

