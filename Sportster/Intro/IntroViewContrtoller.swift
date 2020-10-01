//
//  IntroViewContrtoller.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//

import Foundation
import UIKit

class InterestsViewController: UIViewController {
    
    @IBOutlet weak var interestsLabel: UILabel!
    let interestText = "Interesser"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        

        interestsLabel.text = ""
        //https://stackoverflow.com/a/59463814
        //----------------------------------------
            let titleText = "Interesser"
            var charIndex = 0.0
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                    self.interestsLabel.text?.append(letter)
                }
                 charIndex += 1
            }
        //----------------------------------------

    }
    
}
