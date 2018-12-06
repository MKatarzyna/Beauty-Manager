//
//  TipsViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 30/11/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
    
    var category:String = ""

    @IBAction func sendDataFromFaceCategory(_ sender: Any) {
        category = "Face"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("Where are you?!")
//        if segue.identifier == "Face"
//        {
//            print("Face Category")
//        }
//        else if segue.identifier == "Hair"
//        {
//            print("Hair Category")
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Face" {
            if let vc = segue.destination as? TipsTableVC
            {
                vc.selectedCategory = "Face"
            }
        } else if segue.identifier == "Hair" {
            if let vc = segue.destination as? TipsTableVC
            {
                vc.selectedCategory = "Hair"
            }
        } else if segue.identifier == "Nails" {
            if let vc = segue.destination as? TipsTableVC
            {
                vc.selectedCategory = "Nails"
            }
        } else if segue.identifier == "Body" {
            if let vc = segue.destination as? TipsTableVC
            {
                vc.selectedCategory = "Body"
            }
        }
        
    }

}
