//
//  AppointmentViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 27/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {

    
    @IBOutlet weak var nameOfVisitTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    var appointment: Appointment?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameOfVisitTextField.text = appointment?.name
        dateTextField.text = appointment?.date
        contactTextField.text = appointment?.contact
        addressTextField.text = appointment?.address
        notesTextView.text = appointment?.notes
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    

}
