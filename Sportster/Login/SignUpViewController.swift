//
//  signUpViewController.swift
//  Sportster
//
//  Created by Simon Andersen on 10/01/2021.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var pickProfilePicBtn: UIButton!
    @IBOutlet weak var profilePicIV: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInLoader: UIActivityIndicatorView!
    var profilePicPicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        //Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
        profilePicIV.layer.cornerRadius = profilePicIV.frame.height/2
        pickProfilePicBtn.layer.cornerRadius = 15
        signUpBtn.layer.cornerRadius = 20
    
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
    
    @IBAction func pickProfilePicTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            profilePicPicker.delegate = self
            profilePicPicker.sourceType = .savedPhotosAlbum
            profilePicPicker.allowsEditing = false
            
            present(profilePicPicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.dismiss(animated: true)
        
        if let pickedImage = info[.originalImage] as? UIImage {
                profilePicIV.contentMode = .scaleAspectFill
                profilePicIV.image = pickedImage
            }
        
    }
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
        signInLoader.alpha = 1
        signInLoader.startAnimating()
        signUpBtn.alpha = 0
        
        //Receiving data from view
        let email = emailTF.text!
        let password = passwordTF.text!
        let name = nameTF.text!
        let pfimage = profilePicIV.image!
        let birthdaydate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let birthday = dateFormatter.string(from: birthdaydate)
        
        //Instantiating the firebase login
        Auth.auth().createUser(withEmail: email, password: password) { (user, error1) in
            if error1 != nil {
                print("Something went wrong: Creating new user")
                print(error1?.localizedDescription ?? "Cannot fetch error")
                self.signInLoader.stopAnimating()
                self.signInLoader.alpha = 0
                self.signUpBtn.alpha = 1
                
            } else {
                print("Success: Creating new firebase user")
                let uID = user?.user.uid
                //Creating new user file in the DB with user id from Firestorage
                let newEmailUserRef = Firestore.firestore().collection("user").document((user?.user.uid)!)
                newEmailUserRef.setData(["uid" : uID!, "email": email, "name": name, "birthday": birthday])
            
                //Uploading the selected image to Firebase Storage with user id as name
                let imageName:String = String((user?.user.uid)!+".jpeg")
                let storageRef = Storage.storage().reference().child("profileImages").child(imageName)
                var data: NSData = NSData()
                data = pfimage.jpegData(compressionQuality: 0.8)! as NSData
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                
                storageRef.putData(data as Data, metadata: metaData, completion: { (metaData, error2) in
                    if error2 == nil {
                        print("Success: Uploading profile picture")
                        
                        Auth.auth().signIn(withEmail: email, password: password) { (result, error3) in
                           if error3 == nil {
                            print("Success: Logging new user in")
                            self.signInLoader.stopAnimating()
                            let storyboard = UIStoryboard(name: "Intro", bundle: nil)
                            let vc = storyboard.instantiateViewController(identifier: "IntroVC")
                            self.view.window?.rootViewController = vc
                            self.view.window?.makeKeyAndVisible()
                            
                           }
                           else{
                            print("Something went wrong: Logging new user in")
                            print(error3?.localizedDescription ?? "Cannot fetch error")
                            
                           }
                        }
                        
                    } else {
                        print("Something went wrong: Uploading profile picture")
                        print(error2?.localizedDescription as Any)
                        
                    }
                })
            }
        }
    }
}
