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
    var appointments = [Appointment]()
    var appointment: Appointment?
    var colors = [UIColor.blue,
                  UIColor.yellow,
                  UIColor.green,
                  UIColor.red,
                  UIColor.orange,
                  UIColor.magenta]
    let dateFormatter = DateFormatter()
    
    // wczytanie danych z core data
    @objc func loadCalendarDataFromDB() {
        appointments.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppointmentEntity")
        request.returnsObjectsAsFaults = false
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
                visitsArray.append([nameValue, addressValue])
                dateArray.append(dateValue)
            }
        } catch {
            print("Failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        visitsArray.removeAll()
        dateArray.removeAll()
        loadCalendarDataFromDB()
        reloadData()
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
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        visitsArray.removeAll()
        dateArray.removeAll()
        loadCalendarDataFromDB()
        var events = [Event]()
        
        for i in 0...visitsArray.count-1 {
            let event = Event()
            var visitDate = dateArray[i]
            let duration: Int = Int(appointments[i].duration)!
            var chunk = TimeChunk.dateComponents(minutes: duration)
            let datePeriod = TimePeriod(beginning: visitDate,
                                        chunk: chunk)
            event.startDate = datePeriod.beginning!
            event.endDate = datePeriod.end!
            var info = visitsArray[i]
            event.text = info.reduce("", {$0 + $1 + "\n"})
            event.color = colors[Int(appointments[i].colorNumber)]
            event.isAllDay = appointments[i].isAllDay
            events.append(event)
            event.userInfo = Int(appointments[i].id)
        }
        return events
    }
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString = dateFormatter.string(from: descriptor.startDate)
        let mainTitle = "\(dateFromString)"
        let question = descriptor.text
        let popupDialog = PopupDialog(title: mainTitle, message: question)
        
        // BUTTON CANCEL
        let cancelButton = CancelButton(title: "CANCEL") {
        }
        // BUTTON SHOW MORE
        let yesButton = DefaultButton(title: "SHOW MORE", dismissOnTap: true) {
            self.tabBarController?.selectedIndex = 0
        }
        popupDialog.addButtons([cancelButton, yesButton])
        self.present(popupDialog, animated: true, completion: nil)
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "testedtested", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.center = nav!.center
        let image = UIImage(named: "Colorfull")
        imageView.image = image
        navigationItem.titleView = imageView
    }
}
