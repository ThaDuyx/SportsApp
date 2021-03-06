//
//  ProfileViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 06/10/2020.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Lottie

class OwnerProfileViewController: UIViewController {
    var oid: String = " "
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerInterests: UILabel!
    @IBOutlet weak var ownerLocation: UILabel!
    @IBOutlet weak var ownerDescription: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var loadingAnimation: AnimationView!
    @IBOutlet weak var mainView: UIView!
    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerImage.layer.cornerRadius = ownerImage.frame.height/2
        ownerImage.clipsToBounds = true
        ownerImage.contentMode = .scaleAspectFill
        
        mainView.layer.cornerRadius = 15

        loadingAnimation.loopMode = .loop
        loadingAnimation.play()
        loadingAnimation.alpha = 1
        
        let ownerRef = Firestore.firestore().collection("user").document(oid)
        ownerRef.getDocument { (ownerInfo, error) in
            if error != nil {
                print("Something went wrong: Retrieving owner info")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                let data = ownerInfo?.data()
                let name = data!["name"] as! String
                let interests = data!["interests"] as! [String]
                let location = data!["location"] as! String
                let description = data!["description"] as! String
                let interestsString = interests.joined(separator:", ")
                print(interestsString)
                let ownerImgRef = self.storage.child("profileImages/" + self.oid + ".jpeg")
                ownerImgRef.getData(maxSize: 1 * 1024 * 1024) { (ownerPhoto, error2) in
                    if error2 != nil {
                        print("Something went wrong: Retrieving owner profile image")
                        print(error2?.localizedDescription ?? "Cannot fetch error")
                    } else {
                        let ownerPic = UIImage(data: ownerPhoto!)
                        self.ownerImage.image = ownerPic
                    }
                }
                
                self.ownerName.text = name
                self.ownerInterests.text = interestsString
                self.ownerLocation.text = location
                self.ownerDescription.text = description
                print("Success: Retrieving owner info")
               
                self.ownerImage.alpha = 1
                self.ownerName.alpha = 1
                self.ownerInterests.alpha = 1
                self.ownerLocation.alpha = 1
                self.ownerDescription.alpha = 1
                self.loadingAnimation.stop()
                self.loadingAnimation.alpha = 0
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        ownerImage.alpha = 0
        ownerName.alpha = 0
        ownerLocation.alpha = 0
        ownerDescription.alpha = 0
        ownerInterests.alpha = 0
    }
}
