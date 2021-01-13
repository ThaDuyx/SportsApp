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
    //var pfimage: UIImage
    var email: String
    var name: String
    //var age: String
    var interests: [String]
    var events: [String]
    //var events: [String]
    var location: String
    //var birthday: String

    init?(uid: String, email: String, name: String, location: String, interests: [String], events: [String]) {
        self.uid = uid
        self.email = email
        self.name = name
        self.interests = interests
        self.location = location
        self.events = events
        
    }
    
}
