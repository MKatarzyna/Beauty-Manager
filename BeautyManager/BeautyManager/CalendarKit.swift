//
//  CalendarKit.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 06/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import CalendarKit
import DateToolsSwift
import CoreData
import PopupDialog

class CalendarKit: DayViewController, DatePickerControllerDelegate {

    var visitsArray = [[String]]()
    var dateArray = [Date]()
    
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red]
    
    // wczytanie danych z core data
    @objc func loadCalendarDataFromDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        print("Inside DB.. Reading DB")
        
        // pobranie wszystkich wartości atrybutów z encji
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
//                let idValue = data.value(forKey: "id") as! Int64
                let nameValue = data.value(forKey: "name") as! String
                let dateValue = data.value(forKey: "date") as! Date
//                let contactValue = data.value(forKey: "contact") as! String
                let addressValue = data.value(forKey: "address") as! String
//                let notesValue = data.value(forKey: "notes") as! String
//                let reminderValue = data.value(forKey: "reminder") as! Bool
//                let reminderDateValue = data.value(forKey: "reminderDate") as! Date
                let stringDate = dateFormatter.string(from: dateValue)
//                let stringReminderDate = dateFormatter.string(from: reminderDateValue)
                
                // umieszczenie wartości w obiekcie appointment
//                let appointment = Appointment(
//                    id: idValue,
//                    name: "\(nameValue)",
//                    date: stringDate,
//                    contact: contactValue,
//                    address: addressValue,
//                    notes: notesValue,
//                    reminder: reminderValue,
//                    reminderDate: stringReminderDate)
                // dodanie jednej wizyty do tablicy wizyt (do listy)
//                appointments.append(appointment)
                
                visitsArray.append([nameValue, addressValue])
                dateArray.append(dateValue)
            }
            print(visitsArray)
        } catch {
            print("Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Change Date",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(CalendarKit.presentDatePicker))
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        reloadData()
    }
    
    @objc func presentDatePicker() {
        let picker = DatePickerController()
        picker.date = dayView.state!.selectedDate
        picker.delegate = self
        let navC = UINavigationController(rootViewController: picker)
        navigationController?.present(navC, animated: true, completion: nil)
    }
    
    func datePicker(controller: DatePickerController, didSelect date: Date?) {
        if let date = date {
            dayView.state?.move(to: date)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: EventDataSource
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        visitsArray.removeAll()
        loadCalendarDataFromDB()
        
        var events = [Event]()
        
        print("Count: \(visitsArray.count)")
        
        for i in 0...visitsArray.count-1 {
            let event = Event()
            var visitDate = dateArray[i]
            let duration: Int = 60
            var chunk = TimeChunk.dateComponents(minutes: duration)
            let datePeriod = TimePeriod(beginning: visitDate,
                                        chunk: chunk)
            
            event.startDate = datePeriod.beginning!
            event.endDate = datePeriod.end!
            
            var info = visitsArray[i]
            
            event.text = info.reduce("", {$0 + $1 + "\n"})
            event.color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
            event.isAllDay = false
            events.append(event)
            event.userInfo = String(i)
        }
        
        return events
    }
    
//    private func textColorForEventInDarkTheme(baseColor: UIColor) -> UIColor {
//        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
//        baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
//        return UIColor(hue: h, saturation: s * 0.3, brightness: b, alpha: a)
//    }
    
    // MARK: DayViewDelegate
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        let mainTitle = "Event \(descriptor.startDate)"
        let question = descriptor.text
        let popupDialog = PopupDialog(title: mainTitle, message: question)
        let cancelButton = CancelButton(title: "CLOSE") {
        }
        popupDialog.addButtons([cancelButton])
        self.present(popupDialog, animated: true, completion: nil)
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        print("DayView = \(dayView) did move to: \(date)")
    }
}
