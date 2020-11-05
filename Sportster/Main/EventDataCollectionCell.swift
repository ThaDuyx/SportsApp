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
    
    override func layoutSubviews() {
        eventBackgroundImage.layer.cornerRadius = 10.0
        eventBackgroundImage.layer.masksToBounds = true
        
        profileBtn.layer.cornerRadius = profileBtn.frame.height/2
        profileBtn.clipsToBounds = true
    }
    
}
