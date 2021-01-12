//
//  EventViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/10/2020.
//
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class EventViewController: UIViewController {

    var imgArrTwo = [UIImage(named: "Snowboarding"),
                     UIImage(named: "Background"),
                     UIImage(named: "Profile")]

    @IBOutlet weak var eventBackgroundCollection: UICollectionView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var makeEventBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        eventBackgroundCollection.layer.cornerRadius = 10.0
        eventBackgroundCollection.layer.masksToBounds = true
        
        makeEventBtn.layer.cornerRadius = makeEventBtn.frame.height/2
        makeEventBtn.clipsToBounds = true
        
        
        profileBtn.layer.zPosition = 1
    
        //Firebase CALL
        //retrieveUser()
        
        

    }
}

extension EventViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArrTwo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EventDataCollectionCell
        cell?.eventBackgroundImage.image = imgArrTwo[indexPath.row]
        return cell!
    }
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "TestViewController") as? TestViewController
        vc?.name = imgArrTwo[indexPath.row]
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }*/
    
    func retrieveUser(){
        let uid = Auth.auth().currentUser?.uid
        Firestore.firestore().collection("user").document(uid!).getDocument { (userinfo, error) in
            if error != nil{
                print("Something went wrong: Retrieving user info")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                let data = userinfo?.data()
                let uid = data!["uid"] as! String
                let name = data!["name"] as! String
                let email = data!["email"] as! String
                let interests = data!["interests"] as! [String]
                let location = data!["location"] as! String
                
                let newUser: User = User(uid: uid, email: email, name: name, location: location, interests: interests)!

                print(newUser.uid)
                print(newUser.interests)
            }
        }
        
    }
    
}

extension EventViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: eventBackgroundCollection.frame.size.width, height: eventBackgroundCollection.frame.size.height)
        
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
