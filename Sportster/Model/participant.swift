//
//  participant.swift
//  Sportster
//
//  Created by Simon Andersen on 15/01/2021.
//

import Foundation

class Participant{
    var pid: String
    var name: String
    var status: Bool
    
    init?(pid: String, name: String, status: Bool) {
        self.pid = pid
        self.name = name
        self.status = status
    }
}
