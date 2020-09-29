//
//  IntroViewContrtoller.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//

import Foundation
import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var interestsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
     func viewDidAppear(){
        let interestText = "Interesser"
        for i in interestText {
            interestsLabel.text! += "\(i)"
            RunLoop.current.run(until: Date()+0.1)
            
        }
        
    }
    
}
