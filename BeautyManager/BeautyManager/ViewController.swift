//
//  ViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 19/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData
import PopupDialog

class ViewController: UIViewController {

    var shortTipsArray = [ShortTips]()
    
    @IBAction func showMeShortTip(_ sender: Any) {
        var sizeOfArray: Int = shortTipsArray.count
        print(sizeOfArray)
        let numberOfShortTip = Int.random(in: 0...(sizeOfArray - 1))
        
        let mainTitle = "Short tip"
        let shortTipMessage = shortTipsArray[numberOfShortTip].shortTip
        let popupDialog = PopupDialog(title: mainTitle, message: shortTipMessage)
        let closeButton = CancelButton(title: "CLOSE") {}
        popupDialog.addButtons([closeButton])
        self.present(popupDialog, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadShortTipDataFromDB()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // pobieranie danych z bazy danych ShortTip
    @objc func loadShortTipDataFromDB() {
        print("Loading...")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShortTipEntity")
        request.returnsObjectsAsFaults = false
        
        // pobranie wszystkich wartości atrybutów z encji
        do {
            print("do...")
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let idValue = data.value(forKey: "id") as! Int64
                let shortTipValue = data.value(forKey: "shortTip") as! String
                
                // umieszczenie wartości w obiekcie tip
                let shortTip = ShortTips(
                    id: idValue,
                    shortTip: shortTipValue)
                // dodanie jednej wizyty do tablicy wizyt (do listy)
                shortTipsArray.append(shortTip)
            }
        } catch {
            print("Failed")
        }
    }
}

