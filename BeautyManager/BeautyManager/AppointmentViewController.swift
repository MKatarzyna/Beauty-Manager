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
    
    @IBAction func saveAppointment(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AppointmentEntity", in: context)
        let newAppointment = NSManagedObject(entity: entity!, insertInto: context)
        
        let dateString = dateTextField.text
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = dateFormatter.date(from: dateString!)
        
        newAppointment.setValue(nameOfVisitTextField.text, forKey: "name")
        newAppointment.setValue(dateFromString, forKey: "date")
        newAppointment.setValue(contactTextField.text, forKey: "contact")
        newAppointment.setValue(addressTextField.text, forKey: "address")
        newAppointment.setValue(notesTextView.text, forKey: "notes")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
//    class func deleteAppointment(appointmentValue: AppointmentEntity) -> Bool{
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        context.delete(appointmentValue)
//        do {
//            try context.save()
//            return true
//        } catch {
//            return false
//        }
//    }
    
    func deleteAppointment(name: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "name == %@", name)
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
    
    
    @IBAction func removeAppointment(_ sender: Any) {
        deleteAppointment(name: "paznokcie3")
    }
    
    @IBAction func modifyAppointment(_ sender: Any) {
        editAppointment(name: "paznokcie4")
    }
    
    func editAppointment(name: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        
        let result = try? context.fetch(request)
        let resultData = result as! [AppointmentEntity]
        
        if resultData.count != 0{
           // for object in resultData {
            let dateString = dateTextField.text
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFromString = dateFormatter.date(from: dateString!)
            
            resultData[0].setValue(nameOfVisitTextField.text, forKey: "name")
            resultData[0].setValue(dateFromString, forKey: "date")
            resultData[0].setValue(contactTextField.text, forKey: "contact")
            resultData[0].setValue(addressTextField.text, forKey: "address")
            resultData[0].setValue(notesTextView.text, forKey: "notes")
          //  }
            
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameOfVisitTextField.text = appointment?.name
        dateTextField.text = appointment?.date
        contactTextField.text = appointment?.contact
        addressTextField.text = appointment?.address
        notesTextView.text = appointment?.notes
        
        //AppointmentViewController.deleteAppointment(appointmentValue: appointment![1])
        
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
