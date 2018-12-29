//
//  TipsUITableViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 17/11/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class TipsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedCategory:String = ""
    var cellColor:UIColor = UIColor.clear

    @IBOutlet weak var tableView: UITableView!
    
    var tips = [Tip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if(selectedCategory == "Face"){
            // niebieski
            cellColor = UIColor.init(red: 18.0/255.0, green: 158.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Hair"){
            // violet
            cellColor = UIColor.init(red: 137.0/255.0, green: 118.0/255.0, blue: 241.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Nails"){
            // red
            cellColor = UIColor.init(red: 253.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Body"){
            // pink
            cellColor = UIColor.init(red: 255.0/255.0, green: 158.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tips.removeAll()
        loadTipsDataFromDB()
        tableView.reloadData()
    }
    
    // wczytanie danych z core data
    @objc func loadTipsDataFromDB() {
        print("Loading...")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TipEntity")
        request.returnsObjectsAsFaults = false

        // pobranie wszystkich wartości atrybutów z encji
        do {
            print("do...")
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let idValue = data.value(forKey: "id") as! Int64
                let categoryValue = data.value(forKey: "category") as! String
                let pictureNameValue = data.value(forKey: "pictureName") as! String
                let tipValue = data.value(forKey: "tip") as! String
                let titleValue = data.value(forKey: "title") as! String
                
                print(idValue)
                print(categoryValue)
                print(pictureNameValue)
                print(tipValue)
                print(titleValue)
                
                // sprawdzenie czy porada nalezy wybranej kategorii
                if (categoryValue == selectedCategory) {
                    // umieszczenie wartości w obiekcie tip
                    let tip = Tip(
                        id: idValue,
                        category: categoryValue,
                        pictureName: pictureNameValue,
                        tip: tipValue,
                        title: titleValue)
                    // dodanie jednej wizyty do tablicy wizyt (do listy)
                    tips.append(tip)
                }
                
            }
        } catch {
            print("Failed")
        }
    }
    

    /*
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    */
    // zliczenie elementów z tablicy, aby tableview wiedział ile wierszy ma wyświetlić
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tips.count)
        return tips.count
    }
    
    //wyświetlanie wartości na liście, z duzej litery (capitalize)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        print(" basicCell ")
        cell?.textLabel?.text = tips[indexPath.row].title.capitalized
        return cell!
    }
    
     // jesli wiersz został zaznaczony/klikniety to wykonaj przejscie (segue) o nazwie showdetails
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     performSegue(withIdentifier: "showDetails", sender: self)
     }
    
    // ustawienie koloru komorki w wierszu
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = cellColor
    }
     
     // wysłanie elementu z tablicy appointments dla zaznaczonego wiersza
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TipsDetailsVC {
            destination.tipDetailsArray = tips[(tableView.indexPathForSelectedRow?.row)!]
        }
     }

   


}
