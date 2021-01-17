//
//  TestViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 05/11/2020.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import UIKit

class SpecificEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var participantsTableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var ownerProfileBtn: UIButton!
    @IBOutlet weak var backgroundViewOne: UIView!
    @IBOutlet weak var dbLoader: UIActivityIndicatorView!
    
    

    var selectedEventTitle = ""
    var selectedEid = ""
    var selectedEventDescription = ""
    var selectedEventLocation = ""
    var selectedEventDate = ""
    var selectedOid = ""
    var selectedImage: UIImage = UIImage(named: "defaultArt")!
    var username = ""
    var userID: String = Auth.auth().currentUser!.uid
    
    let dbRef = Firestore.firestore()
    
    var participants = [Participant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        eventImg.layer.cornerRadius = 20
        eventImg.clipsToBounds = true
        
        joinButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        joinedLabel.layer.cornerRadius = 5
        joinedLabel.layer.masksToBounds = true
        
        eventTitle.text = selectedEventTitle
        eventLocation.text = selectedEventLocation
        eventDescription.text = selectedEventDescription
        eventDate.text = selectedEventDate
        eventImg.image = selectedImage
        
        backgroundViewOne.layer.cornerRadius = 15
        dbRef.collection("event").document(selectedEid).collection("participants").addSnapshotListener { (participantsInfo, error) in
            if error != nil {
            print("Something went wrong: Retreiving participants list")
            print(error?.localizedDescription ?? "Cannot fetch error")
                
            } else {
                participantsInfo?.documentChanges.forEach({ (participantChange) in
                    if participantChange.type == .added {
                        let pDataAdded = participantChange.document.data()
                        let pName = pDataAdded["name"] as! String
                        let pId = pDataAdded["pid"] as! String
                        let pStatus = pDataAdded["status"] as! Bool
                        if pStatus == true {
                            self.participants.append(Participant(pid: pId, name: pName, status: pStatus)!)
                            if pId == self.userID {
                                self.joinedLabel.isHidden = false
                                self.joinButton.isHidden = true
                            }
                            DispatchQueue.main.async {
                                self.participantsTableView.reloadData()
                            }
                        } else if pId == self.userID {
                            self.joinButton.isHidden = true
                            self.cancelButton.isHidden = false
                        } else {
                            
                        }
                    }
                    
                    if participantChange.type == .modified {
                        let pDataModified = participantChange.document.data()
                        let pName = pDataModified["name"] as! String
                        let pId = pDataModified["pid"] as! String
                        let pStatus = pDataModified["status"] as! Bool
                        if pStatus == true {
                            self.participants.append(Participant(pid: pId, name: pName, status: pStatus)!)
                            if pId == self.userID {
                                self.joinedLabel.isHidden = false
                                self.joinButton.isHidden = true
                                self.cancelButton.isHidden = true
                            }
                            DispatchQueue.main.async {
                                self.participantsTableView.reloadData()
                            }
                        }
                    }
                    
                    if participantChange.type == .removed{
                        let pDataRemoved = participantChange.document.data()
                        let removedpId = pDataRemoved["pid"] as! String
                        self.participants.removeAll{ $0.pid == removedpId}
                        DispatchQueue.main.async {
                            self.participantsTableView.reloadData()
                            print("Success: Removed participiant")
                        }
                        if removedpId == self.userID {
                            self.joinedLabel.isHidden = true
                            self.cancelButton.isHidden = true
                            self.joinButton.isHidden = false
                        }
                    }
                })
            }
        }
    }
    
    @IBAction func joinBtnTapped(_ sender: Any) {
        dbLoader.startAnimating()
        let dbRef = Firestore.firestore().collection("event").document(selectedEid).collection("participants").document(userID)
        dbRef.setData(["name" : username, "pid": userID, "status": false]) { (error) in
            if error != nil {
                print("Something went wrong: Writing participants to event")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                self.joinButton.isHidden = true
                self.cancelButton.isHidden = false
            }
        }
        dbLoader.stopAnimating()
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let dbRef = Firestore.firestore().collection("event").document(selectedEid).collection("participants")
        dbRef.document(userID).delete()
    }
    
    @IBAction func ownerProfileBtnTapped(_ sender: Any) {
        performSegue(withIdentifier: "showOwnerProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOwnerProfile"{
            let destinationVC = segue.destination as! OwnerProfileViewController
            destinationVC.oid = selectedOid
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.participants.count
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
        let cell = participantsTableView.dequeueReusableCell(withIdentifier: "cell") as! ParticipantsCell
        cell.participantsLabel?.text = participants[indexPath.section].name
        return cell
    }
}
