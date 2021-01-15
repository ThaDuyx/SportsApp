//
//  userEventList.swift
//  Sportster
//
//  Created by Simon Andersen on 15/01/2021.
//

import Foundation

class UserEventList {
    var eid: String
    var title: String
    
    init?(eid: String, title: String) {
        self.eid = eid
        self.title = title
    }
}
