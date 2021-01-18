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
import Lottie

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var pickProfilePicBtn: UIButton!
    @IBOutlet weak var profilePicIV: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var confirmPassswordTF: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loadingAnimationView: AnimationView!
    
    var profilePicPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        //Navigationbar settings - specific color is picked
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        profilePicIV.layer.cornerRadius = profilePicIV.frame.height/2
        pickProfilePicBtn.layer.cornerRadius = 15
        signUpBtn.layer.cornerRadius = 20
        
        loadingAnimationView.alpha = 0
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print(keyboardSize.height)
            if self.mainView.frame.origin.y == 0 {
                if keyboardSize.height <= 216 {
                    self.mainView.frame.origin.y -= 200
                } else if keyboardSize.height > 216 {
                    self.mainView.frame.origin.y -= 100
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.mainView.frame.origin.y != 0 {
            self.mainView.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        
        //Receiving data from view
        let email = emailTF.text!
        let password = passwordTF.text!
        let confirmPassword = confirmPassswordTF.text!
        let passwordLength = passwordTF.text!.count
        let name = nameTF.text!
        let pfimage = profilePicIV.image!
        let birthdaydate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let birthday = dateFormatter.string(from: birthdaydate)

        // Alerts if the user is missing or have typed something wrong
        if password != confirmPassword {
            let refreshAlert = UIAlertController(title: "Det er ikke helt rigtigt", message: "Du har ikke indtastet dit password korrekt ind begge steder", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }else if password == "" {
            let refreshAlert = UIAlertController(title: "Hov, du har vist glemt noget", message: "Du har ikke indtastet et password", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        } else if email == "" {
            let refreshAlert = UIAlertController(title: "Hov, du har vist glemt noget", message: "Du har ikke indtastet en email", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }else if passwordLength < 6 {
            let refreshAlert = UIAlertController(title: "Uh, det skal være lidt længere", message: "Dit password skal være minimum 6 tegn langt", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }else if !email.contains("@"){
            let refreshAlert = UIAlertController(title: "Hov, du har vist glemt noget", message: "Email skal indeholde '@'", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }else if name == "" {
            let refreshAlert = UIAlertController(title: "Har du ikke et navn?", message: "Du skal indtaste dit navn", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: {(action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }else {
            //signInLoader.alpha = 1
            //signInLoader.startAnimating()
            loadingAnimationView.alpha = 1
            loadingAnimationView.loopMode = .loop
            loadingAnimationView.play()
            signUpBtn.alpha = 0
            //Instantiating the firebase login
            Auth.auth().createUser(withEmail: email, password: password) { (user, error1) in
                if error1 != nil {
                    print("Something went wrong: Creating new user")
                    print(error1?.localizedDescription ?? "Cannot fetch error")
                    //self.signInLoader.stopAnimating()
                    //self.signInLoader.alpha = 0
                    self.loadingAnimationView.stop()
                    self.loadingAnimationView.alpha = 0
                    self.signUpBtn.alpha = 1
                    
                } else {
                    print("Success: Creating new firebase user")
                    let uID = user?.user.uid
                    //Creating new user file in the DB with user id from Firestorage
                    let newEmailUserRef = Firestore.firestore().collection("user").document((user?.user.uid)!)
                    newEmailUserRef.setData(["uid" : uID!, "email": email, "name": name, "birthday": birthday])
                    newEmailUserRef.collection("events").document("dummy").setData(["eid" : "dummy"])
                    
                    //Uploading the selected image to Firebase Storage with user id as name
                    let imageName:String = String((user?.user.uid)!+".jpeg")
                    let storageRef = Storage.storage().reference().child("profileImages").child(imageName)
                    var data: NSData = NSData()
                    data = pfimage.jpegData(compressionQuality: 0.2)! as NSData
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpeg"
                    
                    storageRef.putData(data as Data, metadata: metaData, completion: { (metaData, error2) in
                        if error2 == nil {
                            print("Success: Uploading profile picture")
                            
                            Auth.auth().signIn(withEmail: email, password: password) { (result, error3) in
                               if error3 == nil {
                                print("Success: Logging new user in")
                                //self.signInLoader.stopAnimating()
                                self.loadingAnimationView.stop()
                                let storyboard = UIStoryboard(name: "Intro", bundle: nil)
                                let vc = storyboard.instantiateViewController(identifier: "IntroVC")
                                self.view.window?.rootViewController = vc
                                self.view.window?.makeKeyAndVisible()
                               } else {
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
}
