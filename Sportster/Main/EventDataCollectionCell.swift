//
//  EventDataCollectionCell.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/10/2020.
//

import UIKit

class EventDataCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var eventBackgroundImage: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var placementLabel: UILabel!
    
    override func layoutSubviews() {
        eventBackgroundImage.layer.cornerRadius = 10.0
        eventBackgroundImage.layer.masksToBounds = true
        
        profileBtn.layer.cornerRadius = profileBtn.frame.height/2
        profileBtn.clipsToBounds = true
        
        titleLabel.layer.cornerRadius = 20
        titleLabel.layer.masksToBounds = true
    }
}
