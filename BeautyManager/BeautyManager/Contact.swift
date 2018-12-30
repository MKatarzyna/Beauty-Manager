//
//  Contact.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 30/12/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit

class Contact {
    
    var id: Int64
    var address: String
    var contact: String
    var contactName: String
    var mail: String
    var firstName: String
    var lastName: String
    
    init(id: Int64,
         address: String,
         contact: String,
         contactName: String,
         mail: String,
         firstName: String,
         lastName: String)
    {
        self.id = id
        self.address = address
        self.contact = contact
        self.contactName = contactName
        self.mail = mail
        self.firstName = firstName
        self.lastName = lastName
    }
}
