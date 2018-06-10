//
//  CalendarVars.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 10/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
var weekday = calendar.component(.weekday, from: date) - 1
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)
