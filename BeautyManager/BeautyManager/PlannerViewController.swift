//
//  PlannerViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 27/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation

import UIKit

class PlannerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var appointments = [Appointment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appointment1 = Appointment(
            name: "rzesy",
            date: "2018-06-04",
            contact: "123456789",
            address: "Koszalin, ul.Zwycięstwa 54",
            notes: "wizyta umówiona na godzinę 9:30")
        appointments.append(appointment1)
        
        let appointment2 = Appointment(
            name: "brwi",
            date: "2018-06-05",
            contact: "123456789",
            address: "Koszalin, ul.Zwycięstwa 54",
            notes: "wizyta umówiona na godzinę 11:30, pojawić się pół godziny przed czasem aby założyć kartę")
        appointments.append(appointment2)
        
        let appointment3 = Appointment(
            name: "masaż",
            date: "2018-06-10",
            contact: "123456789",
            address: "Koszalin, ul.Jabłoniowa 5",
            notes: "masaż całego ciała, godzina 10, wejście od tyłu budynku")
        appointments.append(appointment3)
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
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
}










