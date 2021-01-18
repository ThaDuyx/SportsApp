//
//  event.swift
//  Sportster
//
//  Created by Simon Andersen on 12/01/2021.
//

import Foundation
import UIKit

class Event{
    var oid: String
    var eid: String
    var title: String
    var eImage: UIImage
    var oImage: UIImage
    var date: String
    var description: String
    var interest: String
    var location: String
    var ownerName: String
    
    init?(oid: String, eid: String, title: String, date: String, description: String, interest: String, location: String, ownerName: String, eImage: UIImage, oImage: UIImage){
        self.oid = oid
        self.eid = eid
        self.title = title
        self.date = date
        self.description = description
        self.interest = interest
        self.location = location
        self.ownerName = ownerName
        self.eImage = eImage
        self.oImage = oImage
    }
}
