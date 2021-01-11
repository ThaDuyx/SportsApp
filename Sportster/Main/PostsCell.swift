//
//  PostsCell.swift
//  Sportster
//
//  Created by Christoffer Detlef on 07/01/2021.
//

import UIKit

class PostsCell: UITableViewCell {
    @IBOutlet weak var bulletinButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bulletinButton.layer.cornerRadius = 10
        bulletinButton.layer.masksToBounds = true
        bulletinButton.clipsToBounds = true
    }
}