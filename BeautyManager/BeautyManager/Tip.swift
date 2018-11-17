//
//  Tip.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 17/11/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit

class Tip {
    
    var id: Int64
    var category: String
    var pictureName: String
    var tip: String
    var title: String

    
    init(id: Int64, category: String, pictureName: String, tip: String, title: String)
    {
        self.id = id
        self.category = category
        self.pictureName = pictureName
        self.tip = tip
        self.title = title
    }
}
