//
//  TestViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 05/11/2020.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    var name: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        img.image = name
    }
}
