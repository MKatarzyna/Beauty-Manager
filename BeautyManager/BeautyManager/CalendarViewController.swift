//
//  CalendarViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 10/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let daysOfMonth = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    var daysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    var numberOfEmptyBox = Int() // the number of "empty boxes" at the start of the current month
    
    var nextNumberOfEmptyBox = Int() // the same with above but with the next month
    
    var previousNumberOfEmptyBox = 0 // the same with above with the prev month
    
    var Direction = 0 // =0 if we are at the current month , = 1 if we are in a future month, =  -1 if we arer in a past month
    
    var positionIndex = 0 // here we will store the above vars of the empty boxes
    
    var leapYearCounter = 2 // it's 2 because the next time February     has 29 days is in two years (it happens every 4 yeara)
    
    var dayCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMonth = months[month]
        monthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0 {
            weekday = 7
        }
        getStartDateDayPosition()
    }
    
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
    
    func getStartDateDayPosition() {    // this functions gives us the number of empty boxes
        switch Direction {
        case 0:                         // if we are at the current month
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
            
        case 1...:                      // if we are at a future month
            nextNumberOfEmptyBox = (positionIndex + daysInMonths[month])%7
            positionIndex = nextNumberOfEmptyBox
            
        case -1:                        // if we are at a past month
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
        
        switch Direction {                  // it returns the number of days in the month + the number of "empty boxes" based on the direction we are going
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
        
        if Int(cell.dateLabel.text!)! < 1 {  // hides every cell that is smaller than 1
            cell.isHidden = true
        }
        
        // show thw weekend days in different color
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:       // the indexes of the collectionViews that matches with the weekend days in every month (they are always the same)
            if Int(cell.dateLabel.text!)! > 0 {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        // marks red the cell the shows the current date
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
