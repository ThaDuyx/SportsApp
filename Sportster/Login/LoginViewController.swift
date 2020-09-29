//
//  LoginViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var topBoxView: UIView!
    @IBOutlet weak var fLoginButton: UIButton!
    @IBOutlet weak var gLoginButton: UIButton!
    @IBOutlet weak var eLoginButton: UIButton!
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewDidLoad()
        
        topBoxView.layer.cornerRadius = topBoxView.frame.size.width/2
        topBoxView.clipsToBounds = true
        
        fLoginButton.layer.cornerRadius = 20
        gLoginButton.layer.cornerRadius = 20
        eLoginButton.layer.cornerRadius = 20
    }
    
}
