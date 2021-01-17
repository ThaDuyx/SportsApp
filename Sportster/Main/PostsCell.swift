//
//  PostsCell.swift
//  Sportster
//
//  Created by Christoffer Detlef on 07/01/2021.
//

import UIKit

class PostsCell: UITableViewCell {
    
    @IBOutlet weak var eventListLabe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.contentView.layer.cornerRadius = 20
            self.contentView.backgroundColor = UIColor.init(rgb:0x2AC0C0)
    }
}
