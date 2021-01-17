//
//  DescriptionViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 15/01/2021.
//

import UIKit

class DescriptionViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var selectedInterests: [String] = []
    var selectedLocation: String = ""

    
    override func viewDidLoad() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        descriptionTextView.text = "Beskriv dig selv med maks. 150 tegn"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor

        //https://stackoverflow.com/a/59463814
        //----------------------------------------
            let titleText = "Beskrivelse_"
            var charIndex = 0.0
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                    self.descriptionTitle.text?.append(letter)
                }
                 charIndex += 1
            }
        //----------------------------------------
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
            print("textViewDidBeginEditing")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Beskriv dig selv med maks. 150 tegn"
            descriptionTextView.textColor = UIColor.lightGray
            print("textViewDidEndEditing")
        }
    }

    //  https://www.youtube.com/watch?v=WSgRbH5-GKc
    //---------    Det stykke kode er taget fra denne video. --------------
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > descriptionTextView.text.count {
            return false
        }
        
        let newLength = descriptionTextView.text.count + text.count - range.length
        return newLength <= 150
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //----------------------------------------
    
    //https://stackoverflow.com/a/26582115
    //----------------------------------------
    func textViewShouldReturn(_ text: UITextView) -> Bool {
            self.view.endEditing(true)
            return false
        }
    //----------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selectedDescription = descriptionTextView.text
        let destinationVC = segue.destination as! NotiViewController
        destinationVC.selectedInterests = selectedInterests
        destinationVC.selectedLocation = selectedLocation
        destinationVC.selectedDescription = selectedDescription!
    }
    
    @IBAction func descriptionButton(_ sender: Any) {
        if (descriptionTextView.text?.isEmpty == true){
            let refreshAlert = UIAlertController(title: "Mangler en beskrivelse", message: "Du har ikke skrevet en beskrivelse", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "showNotiVC", sender: nil)
        }
    }
}
