//
//  ViewController.swift
//  Sportster
//
//  Created by Simon Andersen on 29/09/2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var addEventButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        profileButton.clipsToBounds = true
        
        addEventButton.layer.cornerRadius = addEventButton.frame.height/2
        addEventButton.clipsToBounds = true
        addEventButton.layer.zPosition = 1

        informationButton.layer.cornerRadius = 20

    }

}


