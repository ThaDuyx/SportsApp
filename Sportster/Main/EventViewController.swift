//
//  EventViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/10/2020.
//
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Lottie

class EventViewController: UIViewController {

    var mainUser = User(uid: "", email: "", name: "", location: "", description: "", interests: [], events: [], pfimage: UIImage(named: "Profile")!)
    var eventsList = [Event]()
    var selectedEventEid = ""
    var selectedEventTitle = ""
    var selectedEventLocation = ""
    var selectedEventDate = ""
    var selectedEventDescription = ""
    var selectedEventOwnerID = ""
    var selectedEventImage = UIImage(named: "defaultArt")
        
    @IBOutlet weak var eventBackgroundCollection: UICollectionView!
    @IBOutlet weak var makeEventBtn: UIButton!
    @IBOutlet weak var loadingAnimationView: AnimationView!

    let storage = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        eventBackgroundCollection.layer.cornerRadius = 10
        eventBackgroundCollection.layer.masksToBounds = true
        eventBackgroundCollection.clipsToBounds = true
        makeEventBtn.layer.cornerRadius = makeEventBtn.frame.height/2
        makeEventBtn.clipsToBounds = true
        //profileBtn.layer.zPosition = 1
        eventBackgroundCollection.alpha = 0
        loadingAnimationView.loopMode = .loop
        loadingAnimationView.play()
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Firestore.firestore()
        dbRef.collection("user").document(uid!).getDocument { (userinfo, error) in
            if error != nil{
                print("Something went wrong: Retrieving user info")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else{
                let data = userinfo?.data()
                let uid = data!["uid"] as! String
                let name = data!["name"] as! String
                let email = data!["email"] as! String
                let interests = data!["interests"] as! [String]
                let location = data!["location"] as! String
                let events = data!["events"] as! [String]
                let description = data!["description"] as! String
                let userImgRef = self.storage.child("profileImages/" + uid + ".jpeg")
                userImgRef.getData(maxSize: 1 * 1024 * 1024) { (userImgData, error5) in
                    if error5 != nil {
                        print("Something went wrong: Retrieving profile image")
                        print(error5?.localizedDescription ?? "Cannot fetch error")
                    } else {
                        let userImage = UIImage(data: userImgData!)
                        self.mainUser = User(uid: uid, email: email, name: name, location: location, description: description, interests: interests, events: events, pfimage: userImage!)!
                        print("Success: Retrieving user info")
                        
                        self.mainUser?.interests.forEach({ (interest) in
                            dbRef.collection("event").whereField("interests", isEqualTo: interest).addSnapshotListener { (eventInfo, error2) in
                            if error2 != nil {
                                    print("Something went wrong: Retrieving events")
                                    print(error2?.localizedDescription ?? "Cannot fetch error")
                                } else {
                                    eventInfo?.documentChanges.forEach({ (change) in
                                        if (change.type == .added){
                                            let addedData = change.document.data()
                                            let eid = addedData["eid"] as! String
                                            let oid = addedData["oid"] as! String
                                            let title = addedData["title"] as! String
                                            let description = addedData["description"] as! String
                                            let date = addedData["date"] as! String
                                            let interest = addedData["interests"] as! String
                                            let location = addedData["location"] as! String
                                            let ownerName = addedData["ownername"] as! String
                
                                            let eventImgRef = self.storage.child("eventImages/" + eid + ".jpeg")
                                            eventImgRef.getData(maxSize: 1 * 1024 * 1024) { (eventImgData, error3) in
                                                if error3 != nil {
                                                    print("Something went wrong: Downloading event picture")
                                                    print(error?.localizedDescription ?? "Cannot fetch error")
                                                } else {
                                                    let eventImage = UIImage(data: eventImgData!)
                                                    let ownerImageRef = self.storage.child("profileImages/" + oid + ".jpeg")
                                                    
                                                    ownerImageRef.getData(maxSize: 1 * 1024 * 1024) { (ownerImgData, error4) in
                                                        if error4 != nil {
                                                            print("Something went wrong: Downloading owner picture")
                                                            print(error4?.localizedDescription ?? "Cannot fetch error")
                                                        } else {
                                                            let ownerImage = UIImage(data: ownerImgData!)
                                                            self.eventsList.append(Event(oid: oid, eid: eid, title: title, date: date, description: description, interest: interest, location: location, ownerName: ownerName, eImage: eventImage!, oImage: ownerImage!)!)
                                                            print("Success: Retrieving events")
                                                            DispatchQueue.main.async {
                                                                self.eventBackgroundCollection.reloadData()
                                                                self.eventBackgroundCollection.alpha = 1
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        if (change.type == .modified){
                                            let modifiedData = change.document.data()
                                            for event in self.eventsList{
                                                if modifiedData["eid"] as! String == event.eid{
                                                    event.title = modifiedData["eid"] as! String
                                                    event.location = modifiedData["location"] as! String
                                                    event.date = modifiedData["date"] as! String
                                                    event.description = modifiedData["description"] as! String
                                                    print("Success: Modifying events")
                                                }
                                            }
                                        }
                                        
                                        if (change.type == .removed) {
                                            let removedData = change.document.data()
                                            let removedEid = removedData["eid"] as! String
                                            self.eventsList.removeAll{ $0.eid == removedEid}
                                            self.eventBackgroundCollection.reloadData()
                                            print("Success: Removed event")
                                        }

                                    })
                                }
                            }
                        })

                    }
                }
            }
        }
    }
    @IBAction func makeEventBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "showUserEvents", sender: self)
    }
    
    @IBAction func showUserInfo(_ sender: Any) {
        performSegue(withIdentifier: "showUserInfo", sender: self)
    }
}

extension EventViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? EventDataCollectionCell
        cell?.eventBackgroundImage.image = eventsList[indexPath.row].eImage
        cell?.titleLabel.text = eventsList[indexPath.row].title
        cell?.profileBtn.setImage(eventsList[indexPath.row].oImage, for: .normal)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEventTitle = eventsList[indexPath.row].title
        selectedEventDate = eventsList[indexPath.row].date
        selectedEventDescription = eventsList[indexPath.row].description
        selectedEventLocation = eventsList[indexPath.row].location
        selectedEventOwnerID = eventsList[indexPath.row].oid
        selectedEventEid = eventsList[indexPath.row].eid
        selectedEventImage = eventsList[indexPath.row].eImage
        performSegue(withIdentifier: "showSpecificEvent", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showSpecificEvent"{
            let destinationVC = segue.destination as! SpecificEventViewController
            destinationVC.selectedEventTitle = selectedEventTitle
            destinationVC.selectedEventLocation = selectedEventLocation
            destinationVC.selectedEventDescription = selectedEventDescription
            destinationVC.selectedEventDate = selectedEventDate
            destinationVC.selectedOid = selectedEventOwnerID
            destinationVC.selectedEid = selectedEventEid
            destinationVC.selectedImage = selectedEventImage!
            destinationVC.username = mainUser!.name
        } else if segue.identifier == "showUserInfo" {
            let destinationVC2 = segue.destination as! UserProfileViewController
            destinationVC2.userProfile = self.mainUser
            
        } else if segue.identifier == "showUserEvents" {
            let destinationVC3 = segue.destination as! BulletinViewController
            if self.mainUser?.events.isEmpty != true {
                destinationVC3.eventsIDs = self.mainUser!.events
            }
        }
        
    }
    
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "TestViewController") as? TestViewController
        vc?.name = imgArrTwo[indexPath.row]
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }*/

}

extension EventViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: eventBackgroundCollection.frame.size.width, height: eventBackgroundCollection.frame.size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
