//
//  PictureCollectionViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 12/01/2021.
//

import UIKit

class PictureCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var pictureCollectionView: UICollectionView!

    
    let eventBackground: [UIImage] = [
        UIImage(named: "basketball_bane")!,
        UIImage(named: "basketball")!,
        UIImage(named: "cykling")!,
        UIImage(named: "fitness")!,
        UIImage(named: "fodbold_bold")!,
        UIImage(named: "fodbold")!,
        UIImage(named: "håndbold")!,
        UIImage(named: "kampsport_brydning")!,
        UIImage(named: "kampsport")!,
        UIImage(named: "ski")!,
        UIImage(named: "svømning")!,
        UIImage(named: "tennis")!
    ]

    override func viewDidLoad() {
        //Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    //Dette fjerner navigationsbaren i toppen, når man går væk fra viewet.
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.isTranslucent = false
        self.dismiss(animated:true, completion: nil)
    }
    //Dette viser navigationsbaren i toppen, når man går ind på viewet.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventBackground.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as? PictureCollectionCell
        cell?.eventPictureImage.image = eventBackground[indexPath.row]
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "editEvent") as? EditEventViewController
        vc?.selectedImage = eventBackground[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
}
