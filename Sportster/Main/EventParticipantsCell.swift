//
//  EventParticipantsCell.swift
//  Sportster
//
//  Created by Christoffer Detlef on 11/01/2021.
//

import UIKit

protocol CellDelegate: AnyObject {
    func pProfileTapped(cell: EventParticipantsCell)
    func pAcceptTapped(cell: EventParticipantsCell)
    func pDeclineTapped(cell: EventParticipantsCell)
    func participantButton(cell: EventParticipantsCell)
}

class EventParticipantsCell: UITableViewCell {
    
    @IBOutlet weak var participantButton: UIButton!
    @IBOutlet weak var pProfileBtn: UIButton!
    @IBOutlet weak var pAcceptBtn: UIButton!
    @IBOutlet weak var pDeclineBtn: UIButton!
    
    
    weak var delegate: CellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func pAcceptBtnTapped(_ sender: Any) {
        delegate?.pAcceptTapped(cell: self)
    }
    
    @IBAction func pProfileBtnTapped(_ sender: Any) {
        delegate?.pProfileTapped(cell: self)
    }
    @IBAction func pDeclineBtnTapped(_ sender: Any) {
        delegate?.pDeclineTapped(cell: self)
    }
    
    @IBAction func participantButton(_ sender: Any) {
        delegate?.participantButton(cell: self)
    }
    
    
 
    
}
