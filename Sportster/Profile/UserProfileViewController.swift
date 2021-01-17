//
//  UserProfileViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 06/01/2021.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    @IBOutlet weak var topbarView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    var userProfile = User(uid: "", email: "", name: "", location: "", description: "", interests: [], events: [], pfimage: UIImage(named: "Profile")!)
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userInterestsLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
        //Her bliver viewet i toppen sat en farve, så den passer overens med navigations baren
        self.topbarView.backgroundColor = UIColor.init(rgb: 0x1C8E8E)
        topbarView.layer.cornerRadius = 5
        topbarView.clipsToBounds = true
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
        profileImage.image = userProfile?.pfimage
        
        userNameLabel.text = userProfile?.name
        userLocationLabel.text = userProfile?.location
        let interestsString = userProfile?.interests.joined(separator:", ")
        userInterestsLabel.text = interestsString
        userDescriptionLabel.text = userProfile?.description
        
        backgroundView.layer.cornerRadius = 15
        
        logoutButton.layer.cornerRadius = 10
        logoutButton.clipsToBounds = true
    }
    
    //Dette fjerner navigationsbaren i toppen, når man går væk fra viewet.
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.isTranslucent = false
    }
    //Dette viser navigationsbaren i toppen, når man går ind på viewet.
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func editUserInfo(_ sender: Any) {
        performSegue(withIdentifier: "editUserInfo", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editUserInfo" {
            let destinationVC = segue.destination as! UserProfileEditViewController
            destinationVC.userProfile = self.userProfile
        }
    }
    
    @IBAction func logOutClick(_ sender: Any) {
        let logOutController = UIAlertController(title: "Log Ud", message: "Du er ved at logge ud", preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log Ud", style: .destructive) { (action) in
            do{
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "LoginVC")
                self.present(vc, animated: true, completion: nil)
            } catch let err {
                print(err)
            }
        }
        logOutController.addAction(logOutAction)
        let cancelLogOutAction = UIAlertAction(title: "Annullere", style: .cancel, handler: nil)
        logOutController.addAction(cancelLogOutAction)
        self.present(logOutController, animated: true, completion: nil)
    }
}
