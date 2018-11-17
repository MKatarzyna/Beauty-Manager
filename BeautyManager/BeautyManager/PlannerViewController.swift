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
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appointments.removeAll()
        loadDataFromDB()
        tableView.reloadData()
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    // wczytanie danych z core data
    @objc func loadDataFromDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
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

                let stringDate = dateFormatter.string(from: dateValue)
                
                // umieszczenie wartości w obiekcie appointment
                let appointment = Appointment(
                    id: idValue,
                    name: "\(nameValue)",
                    date: stringDate,
                    contact: contactValue,
                    address: addressValue,
                    notes: notesValue)
                // dodanie jednej wizyty do tablicy wizyt (do listy)
                appointments.append(appointment)
            }
        } catch {
            print("Failed")
        }
    }
    
    // zliczenie elementów z tablicy, aby tableview wiedział ile wierszy ma wyświetlić
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Appointment: ")
        print(appointments.count)
        return appointments.count
    }
    
    //wyświetlanie wartości na liście, z duzej litery (capitalize)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        cell?.textLabel?.text = appointments[indexPath.row].name.capitalized
//        cell?.detailTextLabel?.text = appointments[indexPath.row].date
        print(" basicCell ")
        return cell!
    }
    
    // jesli wiersz został zaznaczony/klikniety to wykonaj przejscie (segue) o nazwie showdetails
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    // wysłanie elementu z tablicy appointments dla zaznaczonego wiersza
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AppointmentViewController {
            destination.appointment = appointments[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
