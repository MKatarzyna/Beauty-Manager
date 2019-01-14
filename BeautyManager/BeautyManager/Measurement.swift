//
//  Measurement.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 17/11/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit

class Measurement {
    var id: Int64
    var resultBMI: Double
    var weight: Double
    var date: Date
    
    init(id: Int64, resultBMI: Double, weight: Double, date: Date)
    {
        self.id = id
        self.resultBMI = resultBMI
        self.weight = weight
        self.date = date
    }
}
