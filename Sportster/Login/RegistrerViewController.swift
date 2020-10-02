//
//  RegistrerViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//

import Foundation
import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

class RegistrerViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBAction func registerButtonTapped(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Intro", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "IntroVC")
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x2AC0C0)
        registerButton.layer.cornerRadius = 20
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

