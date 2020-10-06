//
//  ProfileViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 06/10/2020.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    var imgArr = [UIImage(named: "Snowboarding"),
                  UIImage(named: "Background")]
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var profilePictureCollection: UICollectionView!
    private var gradient: CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileNameLabel.layer.zPosition = 1;

        gradient = CAGradientLayer()
        gradient.frame = informationView.bounds
        gradient.colors = [UIColor.init(rgb: 0x1C8E8E).withAlphaComponent(0.2).cgColor, UIColor.init(rgb: 0x1C8E8E).withAlphaComponent(0.3).cgColor, UIColor.init(rgb: 0x1C8E8E).cgColor, UIColor.init(rgb: 0x1C8E8E).cgColor]
        gradient.locations = [0, 0.05, 0.1, 1]
        informationView.layer.addSublayer(gradient)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gradient.frame = informationView.bounds
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DataCollectionCell
        cell?.profilePicturesImage.image = imgArr[indexPath.row]
        return cell!
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: profilePictureCollection.frame.size.width, height: profilePictureCollection.frame.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
