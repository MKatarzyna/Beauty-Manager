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
import UserNotifications

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var appointments = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appointments.removeAll()
        loadPlannerDataFromDB()
        tableView.reloadData()
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "te", style: .done, target: self, action: nil)
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.center = nav!.center
        let image = UIImage(named: "Colorfull")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    // wczytanie danych z core data
    @objc func loadPlannerDataFromDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // pobranie wszystkich wartości atrybutów z encji
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let idValue = data.value(forKey: "id") as! Int64
                let nameValue = data.value(forKey: "name") as! String
                let dateValue = data.value(forKey: "date") as! Date
                let contactValue = data.value(forKey: "contact") as! String
                let addressValue = data.value(forKey: "address") as! String
                let notesValue = data.value(forKey: "notes") as! String
                let reminderValue = data.value(forKey: "reminder") as! Bool
                let reminderDateValue = data.value(forKey: "reminderDate") as! Date
                let durationValue = data.value(forKey: "duration") as! String
                let colorNumberValue = data.value(forKey: "colorNumber") as! Int64
                let isAllDayValue = data.value(forKey: "isAllDay") as! Bool
                let stringDate = dateFormatter.string(from: dateValue)
                let stringReminderDate = dateFormatter.string(from: reminderDateValue)
                
                // umieszczenie wartości w obiekcie appointment
                let appointment = Appointment(
                    id: idValue,
                    name: "\(nameValue)",
                    date: stringDate,
                    contact: contactValue,
                    address: addressValue,
                    notes: notesValue,
                    reminder: reminderValue,
                    reminderDate: stringReminderDate,
                    duration: durationValue,
                    colorNumber: colorNumberValue,
                    isAllDay: isAllDayValue)
                // dodanie jednej wizyty do tablicy wizyt (do listy)
                appointments.append(appointment)
            }
        } catch {
            print("Failed")
        }
    }
    
    // zliczenie elementów z tablicy, aby tableview wiedział ile wierszy ma wyświetlić
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments.count
    }
    
    //wyświetlanie wartości na liście, z duzej litery (capitalize)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        cell?.textLabel?.text = appointments[indexPath.row].name.capitalized
        print(" basicCell ")
        return cell!
    }
    
    // jesli wiersz został zaznaczony/klikniety to wykonaj przejscie (segue) o nazwie showdetails
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    // wysłanie elementu z tablicy appointments dla zaznaczonego wiersza
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditAppointmentVC {
            destination.appointment = appointments[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
