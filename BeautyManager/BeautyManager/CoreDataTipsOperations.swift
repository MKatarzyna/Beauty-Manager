//
//  CoreDataTipsOperations.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 17/11/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataTipsOperations {
    let dateFormatter = DateFormatter()

    func addTip(categoryValue: String, pictureNameValue: String, tipValue: String, titleValue: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "TipEntity", in: context)
        let newTip = NSManagedObject(entity: entity!, insertInto: context)
        
        let newID = findMaximumID() + 1
        print("NEW ID: \(newID)")
        
        newTip.setValue(newID, forKey: "id")
        newTip.setValue(categoryValue, forKey: "category")
        newTip.setValue(pictureNameValue, forKey: "pictureName")
        newTip.setValue(tipValue, forKey: "tip")
        newTip.setValue(titleValue, forKey: "title")
        
        do {
            try context.save()
            print("saved!")
        }
        catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func findMaximumID() -> Int64 {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TipEntity")
        request.returnsObjectsAsFaults = false
        
        let result = try? context.fetch(request)
        let resultData = result as! [TipEntity]
        
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
    
    
    
    
    
}
