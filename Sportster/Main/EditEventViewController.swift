//
//  EditEventViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 10/01/2021.
//

import UIKit
import Firebase

class EditEventViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var editEventButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var picturePickButton: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var mainView: UIView!
    
    
    let interests: [String] = ["Boldsport", "Cykling", "Skating", "Løb", "Svømning", "Kampsport", "Atletik", "Fitness", "Gymnastik"]
    var cities: [String]?
    var selectedImage = UIImage()
    var selectedEvent = ""
    var eventPicPicker = UIImagePickerController()
    var selectedInterest: String = ""
    var selectedLocation: String = ""
    var eventTitle = ""
    var eventDate = ""
    var eventLocation = ""
    var eventDescription = ""
    var eventInterest = ""
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
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
        
        editEventButton.layer.cornerRadius = 5
        editEventButton.clipsToBounds = true
        
        //picturePickButton.layer.cornerRadius = 5
        //picturePickButton.clipsToBounds = true
        
        let dbRef = Firestore.firestore().collection("event").document(selectedEvent)
        dbRef.getDocument { (editEvent, error) in
            if error != nil {
                print("Something went wrong: Retrieving event")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                let eventRef = editEvent?.data()
                self.eventTitle = eventRef!["title"] as! String
                self.eventDate = eventRef!["date"] as! String
                self.eventDescription = eventRef!["description"] as! String
                self.eventInterest = eventRef!["interests"] as! String
                self.eventLocation = eventRef!["location"] as! String
                self.titleTextView.text = self.eventTitle
                self.descriptionTextView.text = self.eventDescription
                let pickerViewRow = self.cities!.firstIndex(of: self.eventLocation)
                self.locationPicker.selectRow(pickerViewRow!, inComponent: 0, animated: false)
                self.selectedLocation = self.eventLocation
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy, h:mm a"
                let date = dateFormatter.date(from: self.eventDate)
                self.datePicker.date = date!
 
                DispatchQueue.main.async {
                    self.interestsTableView.reloadData()
                }
            }
        }
        
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
        print(selectedImage)
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
            selectedImage = pickedImage
            print(selectedImage)
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
        
        if interests[indexPath.section] == eventInterest {
            self.interestsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
            self.selectedInterest = interests[indexPath.section]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterest = interests[indexPath.section]
    }
    
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
    
    
    @IBAction func editBtnTapped(_ sender: Any) {
        let dbRef = Firestore.firestore().collection("event").document(self.selectedEvent)
        let newTitle = self.titleTextView.text
        let newDescription = self.descriptionTextView.text
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let newDate = dateFormatter.string(from: datePicker.date)
        
        dbRef.setData(["title" : newTitle!, "description" : newDescription!, "interests" : self.selectedInterest, "date" : newDate, "location": selectedLocation], merge: true) { (error) in
            if error != nil {
                print("Something went wrong")
            } else {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
