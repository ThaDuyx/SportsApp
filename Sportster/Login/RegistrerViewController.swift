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

class RegistrerViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLoginLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loadingAnimationView: AnimationView!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        registerButton.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegistrerViewController.tapFunction))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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

        loadingAnimationView.alpha = 0
        emailTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.mainView.frame.origin.y == 0 {
                self.mainView.frame.origin.y -= keyboardSize.height - 70
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
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MainVC")
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            let refreshAlert = UIAlertController(title: "Hov, du har vist glemt noget", message: "Du har glemt enten Password eller email", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        } else {
            loadingAnimationView.alpha = 1
            loadingAnimationView.loopMode = .loop
            loadingAnimationView.play()
            registerButton.alpha = 0
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil {
                    self.loadingAnimationView.stop()
                    self.loadingAnimationView.alpha = 0
                    self.registerButton.alpha = 1
                    print("Something went wrong: Loggning existing user in")
                    print(error?.localizedDescription ?? "Cannot fetch error")
                } else {
                    print("Success: Logging user in")
                    self.registerButton.alpha = 1
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(identifier: "MainVC")
                    
                    self.view.window?.rootViewController = vc
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
}
