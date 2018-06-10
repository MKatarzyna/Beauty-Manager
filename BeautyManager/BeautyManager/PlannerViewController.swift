//
//  PlannerViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 27/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var appointments = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self,
//                                       selector: #selector(PlannerViewController.loadDateFromDB),
//                                       name: .dataDownloadCompleted,
//                                       object: nil)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    @objc func loadDateFromDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        //let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let nameValue = data.value(forKey: "name") as! String
                let dateValue = data.value(forKey: "date") as! Date
                let contactValue = data.value(forKey: "contact") as! String
                let addressValue = data.value(forKey: "address") as! String
                let notesValue = data.value(forKey: "notes") as! String
                //print(data.value(forKey: "name") as! String)
                let stringDate = dateFormatter.string(from: dateValue)
                
                let appointment = Appointment(
                    name: "\(nameValue)",
                    date: stringDate,
                    contact: contactValue,
                    address: addressValue,
                    notes: notesValue)
                appointments.append(appointment)
            }
        } catch {
            print("Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        cell?.textLabel?.text = appointments[indexPath.row].name.capitalized
//        cell?.detailTextLabel?.text = appointments[indexPath.row].date
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AppointmentViewController {
            destination.appointment = appointments[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appointments.removeAll()
        loadDateFromDB()
        tableView.reloadData()
    }
}

//extension Notification.Name {
//    static let dataDownloadCompleted = Notification.Name(
//        rawValue: "dataDownloadCompleted")
//}
