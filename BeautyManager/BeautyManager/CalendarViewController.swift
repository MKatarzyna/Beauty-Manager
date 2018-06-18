//
//  CalendarViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 10/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import Calendar_iOS

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var placeholderView: UIView!
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let daysOfMonth = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var daysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var numberOfEmptyBox = Int() // liczba "empty boxes"(pustych pól) na początku bieżącego miesiąca
    
    var nextNumberOfEmptyBox = Int() // to samo co wyżej ale z następnym miesiącem
    
    var previousNumberOfEmptyBox = 0 // to samo co wyżej ale z poprzednim miesiącem
    
    var Direction = 0 // = 0 jeśli jesteśmy w bieżącym miesiącu, = 1 jeśli jesteśmy w przyszłym miesiącu, = -1 jeśli jesteśmy w poprzednim miesiącu
    
    var positionIndex = 0 // tutaj będziemy przechowywać powyższe zmienne pustych pól
    
    var leapYearCounter = 2 // jest 2, bo następnym razem luty ma 29 dni to za dwa lata (zdarza się co 4 lata)
    
    var dayCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarView = CalendarView(frame: placeholderView.bounds)
        calendarView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        placeholderView.addSubview(calendarView)
        
        calendarView.setMode(CalendarMode.default.rawValue)
        calendarView.shouldMarkToday = true;
        calendarView.shouldShowHeaders = true;
        
        calendarView.selectionColor = UIColor(red: 45.00/255.0, green: 71.00/255.0, blue: 146.00/255.0, alpha: 1.0)
        
        calendarView.refresh()
        
//        calendarView.selectionColor = [UIColor, colorWithRed:0.203 green:0.666 blue:0.862 alpha:1.000];
//        calendarView.fontHeaderColor = [UIColor, colorWithRed:0.203 green:0.666 blue:0.862 alpha:1.000];
//
//        currentMonth = months[month]
//        monthLabel.text = "\(currentMonth) \(year)"
//
//        if weekday == 0 {
//            weekday = 7
//        }
//        getStartDateDayPosition()
    }
    
    // przełączanie na następny miesiąc w kalendarzu
    @IBAction func nextMonth(_ sender: UIButton) {
        
        switch currentMonth {
        case "December":
            month = 0
            year += 1
            Direction = 1
            
            if leapYearCounter < 5 {
                leapYearCounter += 1
            }
            if leapYearCounter == 4 {
                daysInMonths[1] = 29
            }
            if leapYearCounter == 5 {
                leapYearCounter = 1
                daysInMonths[1] = 28
            }
            
            getStartDateDayPosition()
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
            
        default:
            Direction = 1
            
            getStartDateDayPosition()
            
            month += 1
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    // przełączanie na poprzedni miesiąc w kalendarzu
    @IBAction func previousMonth(_ sender: UIButton) {
        
        switch currentMonth {
        case "January":
            month = 11
            year -= 1
            Direction = -1
           
            if leapYearCounter > 0 {
                leapYearCounter -= 1
            }
            if leapYearCounter == 0 {
                daysInMonths[1] = 29
                leapYearCounter = 4
            } else {
                daysInMonths[1] = 28
            }
            
            getStartDateDayPosition()
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        
        default:
            month -= 1
            Direction = -1
            
            getStartDateDayPosition()
            
            currentMonth = months[month]
            monthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    func getStartDateDayPosition() {    // ta funkcja daje nam liczbę pustych pól("empty boxes")
        switch Direction {
        case 0:                         // jeśli jesteśmy w bieżącym miesiącu
            numberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0 {
                numberOfEmptyBox = numberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if numberOfEmptyBox == 0 {
                    numberOfEmptyBox = 7
                }
            }
            if numberOfEmptyBox == 7 {
                numberOfEmptyBox = 0
            }
            positionIndex = numberOfEmptyBox
            
        case 1...:                      // jeśli jesteśmy w przyszłym miesiącu
            nextNumberOfEmptyBox = (positionIndex + daysInMonths[month])%7
            positionIndex = nextNumberOfEmptyBox
            
        case -1:                        // jeśli jesteśmy w zeszłym miesiącu
            previousNumberOfEmptyBox = (7 - (daysInMonths[month] - positionIndex)%7)
            if previousNumberOfEmptyBox == 7 {
                previousNumberOfEmptyBox = 0
            }
            positionIndex = previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch Direction {                  // zwraca liczbę dni w miesiącu + liczbę pustych pól w zależności od kierunku, w którym idziemy
        case 0:
            return daysInMonths[month] + numberOfEmptyBox
        case 1...:
            return daysInMonths[month] + nextNumberOfEmptyBox
        case -1:
            return daysInMonths[month] + previousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear

        cell.dateLabel.textColor = UIColor.black
        
        if cell.isHidden {
            cell.isHidden = false
        }
        
        switch Direction {
        case 0:
            cell.dateLabel.text = "\(indexPath.row + 1 - numberOfEmptyBox)"
        case 1:
            cell.dateLabel.text = "\(indexPath.row + 1 - nextNumberOfEmptyBox)"
        case -1:
            cell.dateLabel.text = "\(indexPath.row + 1 - previousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.dateLabel.text!)! < 1 {  // ukrywa każdą komórkę, która jest mniejsza niż 1
            cell.isHidden = true
        }
        
        // pokaż weekendowe dni w innym kolorze
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:       // indeksy collectionViews, które pasują do weekendowych dni w każdym miesiącu (są zawsze takie same)
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.red
            }
        default:
            break
        }
        // zaznacza pokolorowaną komórkę, pokazuje aktualną datę
        if currentMonth == months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day + positionIndex {
            cell.backgroundColor = UIColor.green
            
//            print("Year: \(year), Today date: \(date), CurrentMonth: \(currentMonth), CalculatedMonth: \(months[calendar.component(.month, from: date) - 1]), Day: \(day), IndexPath: \(indexPath.row + 1)")
        }
        
        if currentMonth == "May" && year == 2018 && (indexPath.row + 1) == 6 + positionIndex {
            cell.backgroundColor = UIColor.blue
        }
        if currentMonth == "May" && year == 2018 && (indexPath.row + 1) == 5 + positionIndex {
            cell.backgroundColor = UIColor(red: 45.00/255.0, green: 71.00/255.0, blue: 146.00/255.0, alpha: 1.0)
        }
        
        return cell
    }
    

}
