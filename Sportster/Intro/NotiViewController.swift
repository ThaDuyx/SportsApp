//
//  NotiViewController.swift
//  Sportster
//
//  Created by Simon Andersen on 01/10/2020.
//

import Foundation
import UIKit

class NotiViewController: UIViewController{
    @IBOutlet weak var notificationLabel: UILabel!
    @IBAction func endIntroTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MainVC")
        
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        

        
        //https://stackoverflow.com/a/59463814
        //----------------------------------------
            let titleText = "Meddelelser_"
            var charIndex = 0.0
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                    self.notificationLabel.text?.append(letter)
                }
                 charIndex += 1
                
            }
        //----------------------------------------
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
}
