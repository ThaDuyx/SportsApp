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
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        profilePicIV.layer.cornerRadius = profilePicIV.frame.height/2
        pickProfilePicBtn.layer.cornerRadius = 15
        signUpBtn.layer.cornerRadius = 20
    
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
        
        //receiving data from view
        let email = emailTF.text!
        let password = passwordTF.text!
        let name = nameTF.text!
        let pfimage = profilePicIV.image!
        let birthdaydate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let birthday = dateFormatter.string(from: birthdaydate)
        
        //Instantiating the firebase login
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Something went wrong")
                print(error?.localizedDescription ?? "Cannot fetch error")
                self.signInLoader.stopAnimating()
                self.signInLoader.alpha = 0
                self.signUpBtn.alpha = 1
                
            } else {
 
                //Creating new user with user id from Firestorage
                let newEmailUserRef = Firestore.firestore().collection("user").document((user?.user.uid)!)
                newEmailUserRef.setData(["uid" : (user?.user.uid)!, "email": email, "name": name, "birthday": birthday])
    
                //Uploading the selected image to Firebase Storage with user id as name
                let imageName:String = String((user?.user.uid)!+".jpeg")
                let storageRef = Storage.storage().reference().child("profileImages").child(imageName)
                var data: NSData = NSData()
                data = pfimage.jpegData(compressionQuality: 0.8)! as NSData
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpeg"
                storageRef.putData(data as Data, metadata: metaData, completion: { (metaData, error) in
                    if error == nil {
                        print("success")
                        self.signInLoader.stopAnimating()
                        let storyboard = UIStoryboard(name: "Intro", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "IntroVC")
                        self.view.window?.rootViewController = vc
                        self.view.window?.makeKeyAndVisible()
                        
                    } else {
                        print(error?.localizedDescription as Any)
                        
                    }
                })
            }
        }
    }
}