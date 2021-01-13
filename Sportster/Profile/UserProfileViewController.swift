//
//  UserProfileViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 06/01/2021.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var topbarView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    var userProfile = User(uid: "String", email: "", name: "", location: "", interests: [], events: [], pfimage: UIImage(named: "Profile")!)
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userInterests: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    
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
        
        userName.text = userProfile?.name
        userLocation.text = userProfile?.location
        let interestsString = userProfile?.interests.joined(separator:", ")
        userInterests.text = interestsString
        profileImage.image = userProfile?.pfimage
        
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
}
