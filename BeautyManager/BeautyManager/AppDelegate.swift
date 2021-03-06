//
//  AppDelegate.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 19/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func addTipEntries() {
        // FACE
        TipsCoreData().addTip(categoryValue: "Face", pictureNameValue: "face_porada001.jpg", tipValue: "face_porada001", titleValue: "Regulacja brwi")
        
        TipsCoreData().addTip(categoryValue: "Face", pictureNameValue: "face_porada002.jpg", tipValue: "face_porada002", titleValue: "Maseczka oczyszczająca")
        
        TipsCoreData().addTip(categoryValue: "Face", pictureNameValue: "face_porada003.jpg", tipValue: "face_porada003", titleValue: "Maseczka nawilżająca - jogurt i ogórek")
        
        TipsCoreData().addTip(categoryValue: "Face", pictureNameValue: "face_porada004.jpg", tipValue: "face_porada004", titleValue: "Maseczka na twarz z miodem")
        
        TipsCoreData().addTip(categoryValue: "Face", pictureNameValue: "face_porada005.jpg", tipValue: "face_porada005", titleValue: "Maseczka na twarz z kawy")
        
        // HAIR
        TipsCoreData().addTip(categoryValue: "Hair", pictureNameValue: "hair_porada001.jpg", tipValue: "hair_porada001", titleValue: "Rozdwojone końcówki - domowe sposoby 1")
        
        TipsCoreData().addTip(categoryValue: "Hair", pictureNameValue: "hair_porada002.jpg", tipValue: "hair_porada002", titleValue: "Rozdwojone końcówki - domowe sposoby 2")
        
        TipsCoreData().addTip(categoryValue: "Hair", pictureNameValue: "hair_porada003.jpg", tipValue: "hair_porada003", titleValue: "Nawilżająca maseczka do włosów")
        
        TipsCoreData().addTip(categoryValue: "Hair", pictureNameValue: "hair_porada004.jpg", tipValue: "hair_porada004", titleValue: "Maska owocowa na włosy")
        
        TipsCoreData().addTip(categoryValue: "Hair", pictureNameValue: "hair_porada005.jpg", tipValue: "hair_porada005", titleValue: "Maseczka z miodem na włosy")
        
        
        // NAILS
        TipsCoreData().addTip(categoryValue: "Nails", pictureNameValue: "nails_porada001.jpg", tipValue: "nails_porada001", titleValue: "Jak wzmocnić paznokcie?")
        
        TipsCoreData().addTip(categoryValue: "Nails", pictureNameValue: "nails_porada002.jpg", tipValue: "nails_porada002", titleValue: "Łamliwe paznokcie")
        
        TipsCoreData().addTip(categoryValue: "Nails", pictureNameValue: "nails_porada003.jpg", tipValue: "nails_porada003", titleValue: "Odżywianie paznokci domowym sposobem")
        
        TipsCoreData().addTip(categoryValue: "Nails", pictureNameValue: "nails_porada004.jpg", tipValue: "nails_porada004", titleValue: "Plan pielęgnacji paznokci")
        
        TipsCoreData().addTip(categoryValue: "Nails", pictureNameValue: "nails_porada005.jpg", tipValue: "nails_porada005", titleValue: "Jak poprawnie piłować paznokcie?")
        
        // BODY
        TipsCoreData().addTip(categoryValue: "Body", pictureNameValue: "body_porada001.jpg", tipValue: "body_porada001", titleValue: "Cukrowy peeling na ciało")
        
        TipsCoreData().addTip(categoryValue: "Body", pictureNameValue: "body_porada002.jpg", tipValue: "body_porada002", titleValue: "Sauna dla ciała i nie tylko")
        
        TipsCoreData().addTip(categoryValue: "Body", pictureNameValue: "body_porada003.jpg", tipValue: "body_porada003", titleValue: "Woda - naturalne nawilżenie ogranizmu")
        
        TipsCoreData().addTip(categoryValue: "Body", pictureNameValue: "body_porada004.jpg", tipValue: "body_porada004", titleValue: "Codzienne nawilżanie skóry")
        
        TipsCoreData().addTip(categoryValue: "Body", pictureNameValue: "body_porada005.jpg", tipValue: "body_porada005", titleValue: "Ochrona skóry przed słońcem")
    }
    
    // SHORT TIPS
    func addShortTipsEntries() {
        ShortTipsCoreData().addShortTip(shortTipValue: "Czy wiesz, że.. codzienne nawilżanie skórek w okół paznokci wazeliną kosmetyczną lub oliwką, odpowiednio je zmiękczy. Dzięki temu Twoje skórki przy paznokciach nie będą się zdzierać.")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Jeśli masz długie włosy, dobrze jeśli przed snem zapleciesz lekki warkocz. Dzięki temu Twoje włosy nie będą się puszyć i łamać.")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Masz lekko zaschięty tusz do rzęs? To nie problem! Wystarczy, że włożysz go na chwilę przed użyciem do naczynia z gorącą wodą lub wlejesz do niego 2-3 krople kropli do oczu, dzięki temu będzie miał znów płynną konsystencję.")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Męczy Cię rano problem z opuchniętymi oczami? Wystarczy, że przyłożysz na parę minut dwa plasterki schłodzonego ogórka lub waciki nasączone zimną wodą, powinno pomóc!")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Dłuższe utrzymywanie się zapachu perfum? Tak! Wystarczy, że spryskasz się perfumami w zgięciach łokci, za uszami i na włosach.")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Zawsze aplikuj kremy na twarz kierując się ku górze, nigdy w dół. Dzieki temu Twoja skóra pozostanie znacznie jędrniejsza.")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Masz problem z doborem odcienia podkładu do Twojej cery? Dobrze mieć w kosmetyczce co najmniej dwa odcienie, na lato ciemniejszy, a na zimę jaśniejszy, bez obaw możesz je też łączyć aby lepiej dopasować do Twojego odcienia!")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Po ciężkim makijażu koniecznie trzeba wykonać delikatny peeling twarzy, pomoże w dokładnym oczyszczeniu porów.")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Wyschnięte i przesuszone usta? Użyj miodu! Nałóż go na usta na kilka minut, bardzo dobrze je nawilży, tylko ciężko się powstrzymać od oblizywania ust :)")
        
        ShortTipsCoreData().addShortTip(shortTipValue: "Aby uniknąć czerwonych i popękanych dłoni w porze jesienno zimowej, staraj dobrze nawilżać dłonie tłustymi kremami, które nie zawieraja w sobie wody lub mają znaczne jej ilości.")
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let hasLaunchedKey = "HasLaunched"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        
        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            addTipEntries()
            
            // modyfikacja dla jednego wpisu
            //            CoreDataTipsOperations().modifyTip(id: 1, categoryValue: "Face", pictureNameValue: "face_porada001.jpg", tipValue: "face_porada001.txt", titleValue: "Jak regulować brwi")
            
            addShortTipsEntries()
        }
        else {
            print("wykonalo sie ponownie")
            // flaga jesli false to wchodzi do if na górze, a jeśli true to wchodzi właśnie do tego elsa
//            defaults.set(false, forKey: hasLaunchedKey)
            
            // usuniecie wszystkich rekordow w bazie danych
//            TipsCoreData().removeAllTips()
//            ShortTipsCoreData().removeAllShortTips()
//            CoreDataOperations().removeAllAppointments()
        }
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BeautyManager")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
