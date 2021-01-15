//
//  DescriptionViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 15/01/2021.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    @IBOutlet weak var descriptionTitle: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    var selectedInterests: [String] = []
    var selectedLocation: String = ""

    
    override func viewDidLoad() {
        
        
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
    
    //https://stackoverflow.com/a/26582115
    //----------------------------------------
    func textViewShouldReturn(_ text: UITextView) -> Bool {
            self.view.endEditing(true)
            return false
        }
    //----------------------------------------
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === descriptionTextView {
            if descriptionTextView.text.isEmpty {
                descriptionTextView.text = "Beskriv dig selv med - maks. 150 tegn"
                descriptionTextView.textColor = UIColor.lightGray
            }
        }
    }
    
    //  https://www.youtube.com/watch?v=WSgRbH5-GKc - Det stykke kode er taget fra denne video.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView === descriptionTextView {
            if range.length + range.location > descriptionTextView.text.count {
                return false
            }
            let newLength = descriptionTextView.text.count + text.count - range.length
            return newLength <= 150
        }
        return true
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
            return
        } else {
            performSegue(withIdentifier: "showLocationVC", sender: nil)
        }
    }
}
