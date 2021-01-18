//
//  TextField.swift
//  Sportster
//
//  Created by Christoffer Detlef on 05/10/2020.
//

import Foundation
import UIKit

//Følgende kode er taget fra følgende hjemmeside.
//https://stackoverflow.com/questions/25367502/create-space-at-the-beginning-of-a-uitextfield

//----------------------------------------
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
//----------------------------------------

