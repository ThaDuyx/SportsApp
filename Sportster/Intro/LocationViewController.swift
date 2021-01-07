//
//  LocationViewController.swift
//  Sportster
//
//  Created by Simon Andersen on 06/01/2021.
//

import Foundation
import UIKit


class LocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    var selectedInterests: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTextField.layer.borderWidth = 2
        locationTextField.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor
        locationTextField.layer.cornerRadius = 15
        self.locationTextField.delegate = self
        
        //https://stackoverflow.com/a/59463814
        //----------------------------------------
            let titleText = "Lokalitet_"
            var charIndex = 0.0
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                    self.locationTitle.text?.append(letter)
                }
                 charIndex += 1
            }
        //----------------------------------------
    }
    
    //https://stackoverflow.com/a/26582115
    //----------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    //----------------------------------------
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedLocation = locationTextField.text
        let destinationVC = segue.destination as! NotiViewController
        destinationVC.selectedInterests = selectedInterests
        destinationVC.selectedLocation = selectedLocation!
    }
    @IBAction func locationButton(_ sender: Any) {
        if (locationTextField.text?.isEmpty == true){
            return
        } else {
            performSegue(withIdentifier: "showNotiVC", sender: nil)
        }
    }
}
