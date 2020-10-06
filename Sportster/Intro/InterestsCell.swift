//
//  CollectionViewCell.swift
//  Sportster
//
//  Created by Simon Andersen on 06/10/2020.
//

import UIKit

class InterestsCell: UICollectionViewCell {
    
    @IBOutlet weak var interestsCellLabel: UILabel!

    
    override var isSelected: Bool {
            didSet {
                if self.isSelected {
                    backgroundColor = UIColor(rgb: 0x2AC0C0)
                    interestsCellLabel.textColor = UIColor.white
                }
                else {
                    backgroundColor = UIColor.white
                    interestsCellLabel.textColor = UIColor(rgb: 0x059EA0)
                }
            }
        }
    
    
    //https://www.vadimbulavin.com/collection-view-cells-self-sizing/
    //--------------------------------------------------------------
    //--------------------------------------------------------------
}
