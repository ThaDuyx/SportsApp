//
//  EventOverviewCell.swift
//  Sportster
//
//  Created by Christoffer Detlef on 10/01/2021.
//

import UIKit

class EventOverviewCell: UITableViewCell {
    
    @IBOutlet weak var eventOverviewImage: UIImageView!
    @IBOutlet weak var eventNameButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventNameButton.layer.cornerRadius = 15
        eventNameButton.clipsToBounds = true
    }
}
