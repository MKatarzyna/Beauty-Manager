//
//  Appointment.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 27/05/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit

class Appointment {
    
    var name: String
    var date: String // zastosować datePicker do wyboru daty
    var contact: String
    var address: String
    var notes: String
    var id: Int64
 
    init(id: Int64, name: String, date: String, contact: String, address: String, notes: String)
    {
        self.name = name
        self.date = date
        self.contact = contact
        self.address = address
        self.notes = notes
        self.id = id
    }
}
