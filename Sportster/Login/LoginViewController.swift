//
//  LoginViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInDelegate {

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
            
        }
        
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
            }
        }
}
    
    /*@IBAction func fButtonTapped(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email", "user_birthday"], from: self) { (result, error) in
            if let error = error{
                print("Login error: \(error.localizedDescription)")
                return
            }
            
            guard AccessToken.current != nil else {
                print("Failed to receive accessToken")
                return
            }
                
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
    
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    print("Login successfull")
                    //let newFBUserRef = Firestore.firestore().collection("user").document((user?.user.uid)!)
                    //newFBUserRef.setData(["uid" : user!.user.uid as Any])
                    //self.getFBUserData()
                    let storyboard = UIStoryboard(name: "Intro", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "IntroVC")
                    self.view.window?.rootViewController = vc
                    self.view.window?.makeKeyAndVisible()
                }
        }
    }
}*/
    
    @IBOutlet weak var topBoxView: UIView!
    @IBOutlet weak var gLoginButton: UIButton!
    @IBOutlet weak var fLoginButton: UIButton!
    @IBOutlet weak var eLoginButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBoxView.layer.cornerRadius = topBoxView.frame.size.width/2
        topBoxView.clipsToBounds = true
        gLoginButton.layer.cornerRadius = 20
        eLoginButton.layer.cornerRadius = 20
        fLoginButton.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapFunction))
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(tap)
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        performSegue(withIdentifier: "showSignUpVC", sender: self)
    }
    
    @IBAction func facebookLoginPressed(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Dette kan du ikke", message: "Dette er endnu ikke blevet implementeret", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func googleLoginPressed(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Dette kan du ikke", message: "Dette er endnu ikke blevet implementeret", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        //        GIDSignIn.sharedInstance().signIn()
    }
    
    //https://stackoverflow.com/a/50447480
    /*//___________________________________________
    func getFBUserData(){
        GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler:
                { (connection, result, error) -> Void in
                    if (error == nil)
                    {
                        //everything works print the user data
                        //                        print(result!)
                        if let data = result as? NSDictionary
                        {
                            let fullname  = data.object(forKey: "name") as? String
                            let email = data.object(forKey: "email") as? String
                            let fid = data.object(forKey: "id") as? String
                            let birthday = data.object(forKey: "user_birthday") as? String
                            
                            print("we are in here")
                            
                            print(fullname!)
                            print(fid!)
                            print(email!)
                            print(birthday ?? "0")
                            
                            //db.setData(["uid" : user.user.uid as Any, "name": fullname!, "email":email!, "fid": fid!])
                            
                            
                        }
                    }
            })
    }*/
    //___________________________________________
}
