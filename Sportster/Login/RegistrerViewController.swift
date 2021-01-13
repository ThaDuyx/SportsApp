//
//  RegistrerViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//

import Foundation
import UIKit
import FirebaseAuth
import Lottie

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

class RegistrerViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLoginLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loadingAnimationView: AnimationView!
    @IBOutlet weak var dbLoader: UIActivityIndicatorView!
    @IBAction func registerButtonTapped(_ sender: Any) {
        dbLoader.startAnimating()
        //loadingAnimationView.loopMode = .loop
        //loadingAnimationView.play()
        registerButton.alpha = 0
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("Something went wrong: Loggning existing user in")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                print("Success: Logging new user in")
                self.dbLoader.stopAnimating()
                //self.loadingAnimationView.stop()
                self.registerButton.alpha = 1
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "MainVC")
                
                self.view.window?.rootViewController = vc
                self.view.window?.makeKeyAndVisible()
            }
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        registerButton.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegistrerViewController.tapFunction))
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(tap)
        
        //https://stackoverflow.com/a/59463814
        //----------------------------------------
            let titleText = "Email Login_"
            var charIndex = 0.0
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                    self.emailLoginLabel.text?.append(letter)
                }
                 charIndex += 1
            }
        //----------------------------------------
        
        //-- Border for Textfield START
        let borderColor = UIColor.init(rgb: 0x2AC0C0)
        emailTextField.layer.borderColor = borderColor.cgColor
        passwordTextField.layer.borderColor = borderColor.cgColor

        emailTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderWidth = 1.0
        
        emailTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 20
        //-- Border for Textfield END

    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MainVC")
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
