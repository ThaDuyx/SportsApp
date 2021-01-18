//
//  UserProfileEditViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 06/01/2021.
//

import UIKit

class UserProfileEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var topbarView: UIView!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var interestsView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var picturePickButton: UIButton!

    let interests: [String] = ["Boldsport", "Cykling", "Skating", "Løb", "Svømning", "Kampsport", "Atletik", "Fitness", "Gymnastik"]
    var userProfile = User(uid: "", email: "", name: "", location: "", description: "", interests: [], events: [], pfimage: UIImage(named: "Profile")!)
    var cities: [String]?
    var selectedInterest: String = ""
    var profilePicPicker = UIImagePickerController()
    var isImagePicked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Navigationbar settings - specific color is picked
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
        // Lets you click anywhere on the screen and will then hide the keyboard.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //The top view color is being matched with the navigations bar color
        self.topbarView.backgroundColor = UIColor.init(rgb: 0x1C8E8E)
        topbarView.layer.cornerRadius = 5
        topbarView.clipsToBounds = true

        saveButton.layer.cornerRadius = 5
        
        interestsTableView.allowsMultipleSelection = true
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        profileImage.image = userProfile?.pfimage
        
        descriptionTextView.text = userProfile?.description
        descriptionTextView.layer.borderWidth = 2
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 15
        descriptionTextView.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor
        
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Beskriv dig selv med maks. 150 tegn"
            descriptionTextView.textColor = UIColor.lightGray
        }
        
        locationView.layer.cornerRadius = 15
        interestsView.layer.cornerRadius = 15
        
        picturePickButton.layer.cornerRadius = 5
        picturePickButton.clipsToBounds = true
        
        parseDanishCities()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.mainView.frame.origin.y == 0 {
                if keyboardSize.height <= 216 {
                    self.mainView.frame.origin.y -= 200
                } else if keyboardSize.height > 216 {
                    self.mainView.frame.origin.y -= 250
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.mainView.frame.origin.y != 0 {
            self.mainView.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            profilePicPicker.delegate = self
            profilePicPicker.sourceType = .savedPhotosAlbum
            profilePicPicker.allowsEditing = false
            present(profilePicPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImage.image = pickedImage
            isImagePicked = true
        }
    }
    
    // TextView description about the length, and making a placeholder
    // --------------- Description textView START ---------------
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGray {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Beskriv dig selv med maks. 150 tegn"
            descriptionTextView.textColor = UIColor.lightGray
        }
    }

    //  https://www.youtube.com/watch?v=WSgRbH5-GKc
    //---------    Det stykke kode er taget fra denne video. --------------
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > descriptionTextView.text.count {
            return false
        }
        let newLength = descriptionTextView.text.count + text.count - range.length
        return newLength <= 150
    }
    //----------------------------------------

    // --------------- Description textView END ---------------
    
    //https://stackoverflow.com/a/26582115
    //----------------------------------------
    func textViewShouldReturn(_ text: UITextView) -> Bool {
            self.view.endEditing(true)
            return false
        }
    //----------------------------------------
    
    func parseDanishCities() {
            do {
                if let path = Bundle.main.path(forResource: "byer", ofType: "txt"){
                    let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                    cities = data.components(separatedBy: "\r")
                }
            } catch let err as NSError {
                print(err)
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.interests.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 33
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = interestsTableView.dequeueReusableCell(withIdentifier: "interestsCell") as! InterestsCell
        cell.interestsCellLabelText?.text = interests[indexPath.section]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(rgb:0x2AC0C0)
        cell.selectedBackgroundView = backgroundView

        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterest = interests[indexPath.section]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities![row]
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
