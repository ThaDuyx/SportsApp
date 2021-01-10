//
//  EventOverviewCell.swift
//  Sportster
//
//  Created by Christoffer Detlef on 10/01/2021.
//

import UIKit

class EventOverviewCell: UITableViewCell {
    
    @IBOutlet weak var eventOverviewImage: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventNameLabel.layer.cornerRadius = 15
        eventNameLabel.clipsToBounds = true
    }
}
