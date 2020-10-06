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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        informationButton.layer.cornerRadius = 20

    }

}

