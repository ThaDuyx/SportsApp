//
//  ProfileViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 06/10/2020.
//

import UIKit

class OwnerProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
}
