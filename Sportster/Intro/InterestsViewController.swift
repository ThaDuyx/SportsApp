//
//  IntroViewContrtoller.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//

import Foundation
import UIKit

class InterestsViewController: UIViewController {
    
    let interests = [" Boldsport + ", " Cykling + ", " Skating + ", " Løb + ", " Svømning + ", " Kampsport + ", " Atletik + ", " Fitness + ", " Gymnastik + "]
    
    
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var interestsCollectionView: UICollectionView!
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout!{
        didSet{
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestsCollectionView.delegate = self
        interestsCollectionView.dataSource = self
        interestsCollectionView.allowsMultipleSelection = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //https://stackoverflow.com/a/59463814
        //----------------------------------------
            let titleText = "Interesser_"
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

extension InterestsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = interests[indexPath.item]
        label.sizeToFit()
        
        return CGSize(width: label.frame.width + 10, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = interestsCollectionView.dequeueReusableCell(withReuseIdentifier: "interestsCell", for: indexPath) as! InterestsCell
        
        cell.interestsCellLabel.text = interests[indexPath.row]
        cell.layer.cornerRadius = 18
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}



