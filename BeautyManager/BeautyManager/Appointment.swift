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
    var reminder: Bool
    var reminderDate: String
    var duration: String
    var colorNumber: Int64
    var isAllDay: Bool
 
    init(id: Int64,
         name: String,
         date: String,
         contact: String,
         address: String,
         notes: String,
         reminder: Bool,
         reminderDate: String,
         duration: String,
         colorNumber: Int64,
         isAllDay: Bool)
    {
        self.name = name
        self.date = date
        self.contact = contact
        self.address = address
        self.notes = notes
        self.id = id
        self.reminder = reminder
        self.reminderDate = reminderDate
        self.duration = duration
        self.colorNumber = colorNumber
        self.isAllDay = isAllDay
    }
}
