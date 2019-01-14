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

class TipsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var selectedCategory:String = ""
    var cellColor:UIColor = UIColor.clear
    var icon: UIImage? = nil

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tips = [Tip]()
    var filteredTipsArray = [Tip]()
    var isSearch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        if(selectedCategory == "Face"){
            // blue
            icon = UIImage(named: "face")
            cellColor = UIColor.init(red: 114.0/255.0, green: 216.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Hair"){
            icon = UIImage(named: "hair")
            // violet
            cellColor = UIColor.init(red: 211.0/255.0, green: 218.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Nails"){
            icon = UIImage(named: "nails")
            // green
            cellColor = UIColor.init(red: 208.0/255.0, green: 242.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Body"){
            icon = UIImage(named: "body2")
            // pink
            cellColor = UIColor.init(red: 252.0/255.0, green: 184.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        }
        self.searchBar.backgroundColor = cellColor
        self.searchBar.isTranslucent = true
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tips.removeAll()
        loadTipsDataFromDB()
        tableView.reloadData()
    }
    
    // wczytanie danych z core data
    @objc func loadTipsDataFromDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TipEntity")
        request.returnsObjectsAsFaults = false

        // pobranie wszystkich wartości atrybutów z encji
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let idValue = data.value(forKey: "id") as! Int64
                let categoryValue = data.value(forKey: "category") as! String
                let pictureNameValue = data.value(forKey: "pictureName") as! String
                let tipValue = data.value(forKey: "tip") as! String
                let titleValue = data.value(forKey: "title") as! String
                
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
    
    // zliczenie elementów z tablicy, aby tableview wiedział ile wierszy ma wyświetlić
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isSearch == true){
            return filteredTipsArray.count
        } else {
            return tips.count
        }
    }
    
    //wyświetlanie wartości na liście, z duzej litery (capitalize)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")
        if(isSearch == true){
            cell?.textLabel?.text = filteredTipsArray[indexPath.row].title.capitalized
            cell?.imageView?.image = icon
        } else {
            cell?.textLabel?.text = tips[indexPath.row].title.capitalized
            cell?.imageView?.image = icon
        }
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text != "") {
            filteredTipsArray = tips.filter({$0.title.lowercased().contains(searchBar.text!.lowercased())})
            isSearch =  true
        } else {
            filteredTipsArray = tips
            isSearch =  false
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        searchBar.text = ""
        tableView.reloadData()
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
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "te", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.center = nav!.center
        let image = UIImage(named: "Colorfull")
        imageView.image = image
        navigationItem.titleView = imageView
    }
}
