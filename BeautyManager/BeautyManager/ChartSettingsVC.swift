//
//  ChartSettingsVC.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 28/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import Toast_Swift
import CoreData

class ChartSettingsVC: UIViewController, UITextFieldDelegate {

    var chartType: Int64 = 0
    var selectedDate: String = ""
    var array = [(Int, Double)]()
    var maxXValue: Double = 0.0
    var year = ""
    var month = ""
    private var datePicker: UIDatePicker?
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func chooseChartType(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
//            KG
            chartType = 0
            print(chartType)
        case 1:
//            BMI
            chartType = 1
            print(chartType)
        default:
            break
        }
    }
    
    @IBAction func drawChart(_ sender: Any) {
        if (dateTextField.text != "") {
            let date = dateTextField.text
            year = String(date![0...3]) // wycina znaki z indeksem od 0 do 3 ze Stringa date, a następnie przypisuje do nowej zmiennej year (wycinanie roku)
            month = String(date![5...6])    // (wycinanie miesiąca)
            let numday = calculateNumbersOfDays(yearValue: year, monthValue: month)
            maxXValue = Double(numday)
            array.removeAll()
            
            // czyszczenie tablicy
            for i in 0...numday-1  {
                array.append((0, 0))
            }

            loadMeasurementsDataFromDB()
            array = array.filter { $0 != (0, 0.0) }
            
            if (array.isEmpty) {
                self.view.makeToast("No records for that date.", duration: 3.0, position: .bottom)
            } else {
                performSegue(withIdentifier: "ShowChart", sender: sender)
            }
        } else {
            self.view.makeToast("Please, select month and year.", duration: 3.0, position: .bottom)
        }
    }
    
    func calculateNumbersOfDays(yearValue: String, monthValue: String) -> Int {
        var dateComponents = DateComponents()
        dateComponents.year = Int(year)
        dateComponents.month = Int(month)
        let currentCalendarValue = Calendar.current
        let currentDate = currentCalendarValue.date(from: dateComponents)
        let interval = currentCalendarValue.dateInterval(of: .month, for: currentDate!)!
        let numberOfDays = currentCalendarValue.dateComponents([.day], from: interval.start, to: interval.end).day!
        return numberOfDays
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(BMIViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BMIViewController.viewTapped(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        dateTextField.inputView = datePicker
        self.hideKeyboardWhenTappedAround()
        self.dateTextField.delegate = self
        loadMeasurementsDataFromDB()
        dateTextField.text = getCurrentDate()
    }
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        return dateFormatter.string(from: date)
    }
    
    func loadMeasurementsDataFromDB(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MeasurementsEntity")
        request.returnsObjectsAsFaults = false
        let dateFormatterForYear = DateFormatter()
        dateFormatterForYear.dateFormat = "yyyy"
        let dateFormatterForMonth = DateFormatter()
        dateFormatterForMonth.dateFormat = "MM"
        let dateFormatterForDay = DateFormatter()
        dateFormatterForDay.dateFormat = "dd"
        
        // pobranie wszystkich wartości atrybutów z encji
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let idValue = data.value(forKey: "id") as! Int64
                let weightValue = data.value(forKey: "weight") as! Double
                let resultBmiValue = data.value(forKey: "resultBMI") as! Double
                let dateValue = data.value(forKey: "date") as! Date
                let yearDate = dateFormatterForYear.string(from: dateValue)
                let monthDate = dateFormatterForMonth.string(from: dateValue)
                let dayDate: Int = Int(dateFormatterForDay.string(from: dateValue))!
                
                if(yearDate == year && monthDate == month){
                    print("YearDate: \(yearDate), MonthDate: \(monthDate), DayDate: \(dayDate)")
                    if (chartType == 0) {
                        array.insert((dayDate, weightValue), at: dayDate-1)
                    } else if (chartType == 1) {
                        array.insert((dayDate, resultBmiValue), at: dayDate-1)
                    }
                }
            }
        } catch {
            print("Failed")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // zabezpieczenie datePickera przed wklejaniem tresci i dodawaniem innych znaków niż te podane poprzez dataPicker
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateTextField {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func viewTapped(gestureRecognize: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        selectedDate = dateTextField.text!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ChartData {
            destination.chartType = chartType
            destination.selectedDate = selectedDate
            destination.array = array
            destination.maxXValue = maxXValue
            destination.year = year
            destination.month = month
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: ".", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.center = nav!.center
        let image = UIImage(named: "Colorfull")
        imageView.image = image
        navigationItem.titleView = imageView
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
}
extension Substring {
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
}
