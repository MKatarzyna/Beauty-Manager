//
//  BMIViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 08/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit
import Toast_Swift


public extension UIViewController {
    public func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
}

class BMIViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var kgTextField: UITextField!
    @IBOutlet weak var cmTextField: UITextField!
    @IBOutlet weak var scoreBMILabel: UILabel!
    //@IBOutlet weak var descriptionBMILabel: UILabel!

    @IBOutlet weak var descriptionBMILabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // use this to hide keyboard while pressing return on keyboard
        self.kgTextField.delegate = self
        self.cmTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateBMI(_ sender: Any) {
        
        if (kgTextField.text != "" && cmTextField.text != "")
        {
            if(kgTextField.text?.rangeOfCharacter(from: CharacterSet.letters) == nil &&
                cmTextField.text?.rangeOfCharacter(from: CharacterSet.letters) == nil)
            {
                let kgValue = Double(kgTextField.text!)
                let cmValue = Double(cmTextField.text!)
                let mValue = Double(cmValue!/100.0)
                
                let resultBmi = Double(kgValue! / (mValue * mValue))
                
                scoreBMILabel.text = "Your BMI is: \(resultBmi)"
                var result = "toast"
                var style = ToastStyle()
                
                if (resultBmi < 16.0)
                {
                    // purple
                    result = "wygłodzenie"
                    descriptionBMILabel.text = "Osłabienie organizmu w wyniku długotrwałego niejedzenia lub niedojadania. To groźny dla zdrowia i życia stan, w którym niezbędna może być hospitalizacja. Wygłodzenie stwierdzane jest, gdy Body Mass Index spada poniżej 15. Najczęściej przypadłość ta dotyka kobiet. Oczywiście normę tą obliczać powinny tylko osoby dorosłe, ponieważ u dzieci stan wagi określa się za pomocą siatek centylowych."
                    style.backgroundColor = UIColor(red: 97.0/255.0, green: 66.0/255.0, blue: 148.0/255.0, alpha: 1.0)
                }
                else if (resultBmi > 16.0 && resultBmi < 16.99)
                {
                    // dark blue
                    result = "wychudzenie"
                    descriptionBMILabel.text = "Stan wychudzenia związany z zaburzeniami odżywiania jest groźnym stanem dla zdrowia. Przyjmuje się jego występowanie, gdy Body Mass Index spada poniżej 17. Zazwyczaj przypadłość ta dotyka kobiet. Oczywiście - wskaźnik ten powinny obliczać tylko osoby dorosłe. U dzieci stan wagi określa się za pomocą siatek centylowych."
                    style.backgroundColor = UIColor(red: 20.0/255.0, green: 100.0/255.0, blue: 210.0/255.0, alpha: 1.0)
                }
                else if (resultBmi > 17.0 && resultBmi < 18.49)
                {
                    // turqoise
                    result = "niedowaga"
                    descriptionBMILabel.text = "Niedowaga to stan masy ciała poniżej wartości uznanych za prawidłowe dla osób o danym wzroście, płci i w określonym wieku. Spowodowana jest utrzymującym się ujemnym bilansem energetycznym. Przejawia się m.in. osłabieniem systemu odpornościowego, niskim ciśnieniem krwi, anemią, osłabieniem kości, uczuciem zimna i nieregularną miesiączką."
                    style.backgroundColor = UIColor(red: 55.0/255.0, green: 182.0/255.0, blue: 197.0/255.0, alpha: 1.0)
                }
                else if (resultBmi > 18.50 && resultBmi < 24.99)
                {
                    // green
                    result = "wartość prawidłowa"
                    descriptionBMILabel.text = "Osoby posiadające taką właśnie wartość BMI nie mają się czym martwić. Oznacza to, że ich styl życia jest zdrowy i przyjazny dla organizmu."
                    style.backgroundColor = UIColor(red: 0.0/255.0, green: 221.0/255.0, blue: 48.0/255.0, alpha: 1.0)
                }
                else if (resultBmi > 25.0 && resultBmi < 29.99)
                {
                    // yellow
                    result = "nadwaga"
                    descriptionBMILabel.text = "Osoby posiadające taki wynik BMI nie powinny się przesadnie martwić o swoje zdrowie. Nie oznacza to jednak, że nie potrzebują lekkiej zmiany stylu życia. Wskazana jest w tym przypadku zmiana codziennej diety. Osoby z nadwagą powinny zmniejszyć ilość spożywania posiłków zawierających szkodliwe dla organizmu cukry."
                    style.backgroundColor = UIColor(red: 284.0/255.0, green: 221.0/255.0, blue: 48.0/255.0, alpha: 1.0)
                }
                else if (resultBmi > 30.0 && resultBmi < 34.99)
                {
                    // orange
                    result = "I stopień otyłości"
                    descriptionBMILabel.text = "Otyłość to stan, w przebiegu którego w organizmie zmagazynowany jest nadmiar tkanki tłuszczowej, co przekłada się na zwiększoną masę ciała. Przy braku działań korygujących w żywieniu i zakresie aktywności fizycznej często prowadzi do otyłości pierwszego stopnia."
                    style.backgroundColor = UIColor(red: 255.0/255.0, green: 160.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                }
                else if (resultBmi > 35.0 && resultBmi < 39.99)
                {
                    // red
                    result = "II stopień otyłości"
                    descriptionBMILabel.text = "Otyłość to choroba, która nieleczona może prowadzić do poważnych komplikacji zdrowotnych m.in. cukrzycy, miażdżycy, chorób serca, nadciśnienia tętniczego, w skrajnych przypadkach nawet do śmierci. Warto zdać sobie sprawę, że przede wszystkim to my sami jesteśmy odpowiedzialni za powstanie otyłości, możemy jej więc też zapobiec!"
                    style.backgroundColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                }
                else if (resultBmi > 40.0)
                {
                    // dark red
                    result = "otyłość skrajna"
                    descriptionBMILabel.text = "Ten wynik wskazuje, że cierpisz na skrajną otyłość i wymagasz natychmiastowej wielospecjalistycznej opieki medycznej. Zgłoś się niezwłocznie do swojego lekarza! Zadbaj natychmiast o swoje zdrowie! Z otyłości można się wyleczyć! Znajdujesz się w grupie wysokiego ryzyka rozwoju takich powikłań otyłości jak: nadciśnienie tętnicze, cukrzyca, choroba niedokrwienna serca."
                    style.backgroundColor = UIColor(red: 165.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                }
                style.messageColor = .white
                self.view.makeToast(result, duration: 3.0, position: .bottom, style: style)
            }
            else
            {
                self.view.makeToast("Please, use only numbers.", duration: 3.0, position: .bottom)
            }
        }
        else
        {
            self.view.makeToast("Please, fill both text fields :)", duration: 3.0, position: .bottom)
        }
    }
}
