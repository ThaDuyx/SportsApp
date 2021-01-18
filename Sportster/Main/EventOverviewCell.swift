//
//  EventOverviewCell.swift
//  Sportster
//
//  Created by Christoffer Detlef on 10/01/2021.
//

import UIKit

class EventOverviewCell: UITableViewCell {
    
    @IBOutlet weak var eventOverviewImage: UIImageView!
    @IBOutlet weak var eventOverviewLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventOverviewLabel.layer.cornerRadius = 15
        eventOverviewLabel.clipsToBounds = true
    }
}
