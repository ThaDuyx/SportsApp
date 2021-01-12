//
//  CreateEventViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 08/01/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateEventViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var picturePickButton: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var interestsTableView: UITableView!
    @IBOutlet weak var locationPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    var selectedLocation: String = ""
    var selectedInterests: [String] = []
    
    let interests: [String] = ["Boldsport", "Cykling", "Skating", "Løb", "Svømning", "Kampsport", "Atletik", "Fitness", "Gymnastik"]
    var cities: [String]?
    
    override func viewDidLoad() {
        //Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
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
        selectedInterests.append(interests[indexPath.section])
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
        selectedLocation.append(cities![row])
    }
    
    func postEvent() {
        let ownerid = Auth.auth().currentUser?.uid
        let title = titleTextView.text
        let location = selectedLocation
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
        let date = dateFormatter.string(from: datePicker.date)
        let interests = selectedInterests
        let description = descriptionTextView.text
        
        let newEventRef = Firestore.firestore().collection("event").document()
        let eventid = newEventRef.documentID
        //newEventRef.setData(["eid":eventid, "oid":ownerid!, ])
    }
}
