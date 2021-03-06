//
//  user.swift
//  Sportster
//
//  Created by Simon Andersen on 11/01/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class User {
    var uid: String
    var pfimage: UIImage
    var email: String
    var name: String
    var interests: [String]
    var events: [String]
    var location: String
    var description: String

    init?(uid: String, email: String, name: String, location: String, description: String, interests: [String], events: [String], pfimage: UIImage) {
        self.uid = uid
        self.email = email
        self.name = name
        self.interests = interests
        self.location = location
        self.events = events
        self.pfimage = pfimage
        self.description = description
    }
    
}
