//
//  BMIViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 08/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit

class BMIViewController: UIViewController {
    @IBOutlet weak var kgTextField: UITextField!
    @IBOutlet weak var cmTextField: UITextField!
    @IBOutlet weak var scoreBMILabel: UILabel!
    @IBOutlet weak var descriptionBMILabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func calculateBMI(_ sender: Any) {
        
        let kgValue = Double(kgTextField.text!)
        let cmValue = Double(cmTextField.text!)
        let mValue = Double(cmValue!/100.0)
        
        let resultBmi = Double(kgValue! / (mValue * mValue))
        
        scoreBMILabel.text = "Your BMI is: \(resultBmi)"
        
        if (resultBmi < 16.0)
        {
            descriptionBMILabel.text = "wygłodzenie"
        }
        else if (resultBmi > 16.0 && resultBmi < 16.99)
        {
            descriptionBMILabel.text = "wychudzenie"
        }
        else if (resultBmi > 17.0 && resultBmi < 18.49)
        {
            descriptionBMILabel.text = "niedowaga"
        }
        else if (resultBmi > 18.50 && resultBmi < 24.99)
        {
            descriptionBMILabel.text = "wartość prawidłowa"
        }
        else if (resultBmi > 25.0 && resultBmi < 29.99)
        {
            descriptionBMILabel.text = "nadwaga"
        }
        else if (resultBmi > 30.0 && resultBmi < 34.99)
        {
            descriptionBMILabel.text = "I stopień otyłości"
        }
        else if (resultBmi > 35.0 && resultBmi < 39.99)
        {
            descriptionBMILabel.text = "II stopień otyłości"
        }
        else if (resultBmi > 40.0)
        {
            descriptionBMILabel.text = "otyłóść skrajna"
        }
    }
    


}
