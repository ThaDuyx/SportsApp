//
//  CreateEventViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 08/01/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class CreateEventViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var picturePickButton: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dbLoader: UIActivityIndicatorView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var eventImage: UIImageView!
    var selectedLocation: String = ""
    var selectedInterest: String = ""
    var eventPicPicker = UIImagePickerController()
    var isImagePicked: Bool = false
    var selectedImage = UIImage()
    var userName: String = ""
    
    let interests: [String] = ["Boldsport", "Cykling", "Skating", "Løb", "Svømning", "Kampsport", "Atletik", "Fitness", "Gymnastik"]
    var cities: [String]?
    
    override func viewDidLoad() {
        print(userName)
        //Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        descriptionTextView.text = "Beskriv begivenheden - maks. 150 tegn"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 5
        
        titleTextView.text = "Title - maks. 20 tegn"
        titleTextView.textColor = UIColor.lightGray
        titleTextView.layer.masksToBounds = true
        
        createEventButton.layer.cornerRadius = 5
        createEventButton.clipsToBounds = true
        
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
    
    @IBAction func pickEventImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            eventPicPicker.delegate = self
            eventPicPicker.sourceType = .savedPhotosAlbum
            eventPicPicker.allowsEditing = false
            
            present(eventPicPicker, animated: true, completion: nil)
            
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)
        
        if let pickedImage = info[.originalImage] as? UIImage {
            eventImage.image = pickedImage
            isImagePicked = true
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === descriptionTextView{
            if descriptionTextView.textColor == UIColor.lightGray {
                descriptionTextView.text = nil
                descriptionTextView.textColor = UIColor.black
            }
        } else if textView === titleTextView {
            if titleTextView.textColor == UIColor.lightGray {
            titleTextView.text = nil
            titleTextView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === descriptionTextView {
            if descriptionTextView.text.isEmpty {
                descriptionTextView.text = "Beskriv begivenheden - maks. 150 tegn"
                descriptionTextView.textColor = UIColor.lightGray
            }
        } else if textView === titleTextView {
            if titleTextView.text.isEmpty {
                titleTextView.text = "Title - maks. 20 tegn"
                titleTextView.textColor = UIColor.lightGray
            }
        }
    }

    //  https://www.youtube.com/watch?v=WSgRbH5-GKc - Det stykke kode er taget fra denne video.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView === titleTextView {
            if range.length + range.location > titleTextView.text.count {
                return false
            }
            
            let newLength = titleTextView.text.count + text.count - range.length
            return newLength <= 20
        } else if textView === descriptionTextView {
            if range.length + range.location > descriptionTextView.text.count {
                return false
            }
            
            let newLength = descriptionTextView.text.count + text.count - range.length
            return newLength <= 150
        }
        return true
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
    
    func parseDanishCities() {
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "byer", ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                cities = data.components(separatedBy: "\r")
            }
        } catch let err as NSError {
            // do something with Error
            print(err)
        }
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = cities![row]
    }
    @IBAction func createEventBtnTapped(_ sender: Any) {
        if selectedInterest.isEmpty {
            let refreshAlert = UIAlertController(title: "Mangler interesse", message: "Du har ikke valgt en interesse", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        } else if descriptionTextView.text == "Beskriv begivenheden - maks. 150 tegn"{
            let refreshAlert = UIAlertController(title: "Mangler en beskrivelse", message: "Du har ikke skrevet en beskrivelse", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        }else if titleTextView.text == "Title - maks. 20 tegn"{
            let refreshAlert = UIAlertController(title: "Mangler en title", message: "Du har ikke skrevet en title", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        } else {
        print("jeg er i else")
        dbLoader.alpha = 1
        dbLoader.startAnimating()
        createEventButton.alpha = 0
        postEvent()
        }
    }
    
    func postEvent() {
        
        //Posting the event data in Firebase/event
        let ownerid = Auth.auth().currentUser?.uid
        let title = titleTextView.text
        let location = selectedLocation
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let date = dateFormatter.string(from: datePicker.date)
        let interests = selectedInterest
        let description = descriptionTextView.text
        
        //Adding event to event collection
        let newEventRef = Firestore.firestore().collection("event").document()
        let eventid = newEventRef.documentID
        newEventRef.setData(["eid":eventid, "oid":ownerid!, "title":title!, "location": location, "date": date, "interests":interests, "description": description!, "ownername": userName]) { (error1) in
            if error1 != nil {
                print("Something went wrong: Posting event")
                print(error1?.localizedDescription ?? "Cannot fetch error")
            } else {
                print("Success: Posting in event collection")
                
                //Adding eventid in firebase/user/events
                let userRef = Firestore.firestore().collection("user").document(ownerid!).collection("events").document(eventid)
                userRef.setData(["eid": eventid]) { (error2) in
                    if error2 != nil {
                        print("Something went wrong: Posting event to owner")
                        print(error2?.localizedDescription ?? "Cannot fetch error")
                    } else {
                        print("Success: Posting event to owner")
                        
                        if self.isImagePicked == false {
                            self.selectedImage = UIImage(named: "SportImages/"+self.selectedInterest)!
                        }
                        let imageName:String = String((eventid)+".jpeg")
                        let storageRef = Storage.storage().reference().child("eventImages").child(imageName)
                        var data: NSData = NSData()
                        data = self.selectedImage.jpegData(compressionQuality: 0.8)! as NSData
                        let metaData = StorageMetadata()
                        metaData.contentType = "image/jpeg"
                        storageRef.putData(data as Data, metadata: metaData) { (metaData, error3) in
                            if error3 != nil {
                                print("Something went wrong: Uploading image eventImages")
                                print(error3?.localizedDescription ?? "Cannot fetch error")
                            } else {
                                print("Success: Uploading image to eventImages")
                                
                                self.createEventButton.alpha = 1
                                self.dbLoader.stopAnimating()
                                self.dbLoader.alpha = 0
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
        //End of dbRef.setData
    }
}
