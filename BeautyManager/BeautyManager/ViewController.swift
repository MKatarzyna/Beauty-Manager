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
import UserNotifications

class ViewController: UIViewController {
    var shortTipsArray = [ShortTips]()
    
    @IBAction func showMeShortTip(_ sender: Any) {
        var sizeOfArray: Int = shortTipsArray.count
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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // pobieranie danych z bazy danych ShortTip
    @objc func loadShortTipDataFromDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ShortTipEntity")
        request.returnsObjectsAsFaults = false
        
        // pobranie wszystkich wartości atrybutów z encji
        do {
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
