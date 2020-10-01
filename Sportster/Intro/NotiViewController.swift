//
//  NotiViewController.swift
//  Sportster
//
//  Created by Simon Andersen on 01/10/2020.
//

import Foundation
import UIKit

class NotiViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
