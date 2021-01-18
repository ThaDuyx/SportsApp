//
//  EventOverviewViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 10/01/2021.
//

import UIKit
import Firebase

class EventOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedEventEid = ""
    var selectedEventTitle = ""
    var selectedEventLocation = ""
    var selectedEventDate = ""
    var selectedEventDescription = ""
    var selectedEventOwnerID = ""
    var selectedEventImage = UIImage()
    var username = ""
    
    
    @IBOutlet weak var eventOverviewTableView: UITableView!
    var eventsList = [Event]()
    let userID = Auth.auth().currentUser?.uid
    let dbRef = Firestore.firestore().collection("user").document()
    var participationList = [Participant]()
    
    override func viewDidLoad() {
        
        let dbRef = Firestore.firestore().collection("user").document(userID!).collection("participations")
        dbRef.addSnapshotListener { (participation, error) in
            if error != nil {
                print("Something went wrong")
            } else {
                participation?.documentChanges.forEach({ (change) in
                    if error != nil {
                        print("Something went wrong")
                    } else {
                        if change.type == .added {
                            let addedData = change.document.data()
                            let eid = addedData["eid"] as! String
                            let eventName = addedData["name"] as! String
                            let status = addedData["status"] as! Bool
                            self.participationList.append(Participant(pid: eid, name: eventName, status: status)!)
                            DispatchQueue.main.async {
                                self.eventOverviewTableView.reloadData()
                            }
                        }
                        
                        if change.type == .modified {
                            let modifiedData = change.document.data()
                            for participation in self.participationList{
                                if modifiedData["eid"] as! String == participation.pid{
                                    participation.status = modifiedData["status"] as! Bool
                                    DispatchQueue.main.async {
                                        self.eventOverviewTableView.reloadData()
                                    }
                                }
                            }
                        }
                        
                        if change.type == .removed {
                            let removedData = change.document.data()
                            let removedEid = removedData["eid"] as! String
                            self.participationList.removeAll{ $0.pid == removedEid}
                            DispatchQueue.main.async {
                                self.eventOverviewTableView.reloadData()
                                print("Success: Removed event")
                                
                            }
                        }
                    }
                })
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return participationList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventOverviewTableView.dequeueReusableCell(withIdentifier: "eventOverviewCell") as! EventOverviewCell
        
        if participationList[indexPath.section].status == true {
            cell.eventOverviewImage.image = UIImage(systemName: "checkmark.square.fill")
        }
        
        cell.eventNameButton.setTitle(participationList[indexPath.section].name, for: .normal)
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for event in eventsList {
            if event.eid == participationList[indexPath.section].pid {
                selectedEventEid = event.eid
                selectedEventDate = event.date
                selectedEventTitle = event.title
                selectedEventLocation = event.location
                selectedEventDescription = event.location
                selectedEventImage = event.eImage
                selectedEventOwnerID = event.oid
                performSegue(withIdentifier: "showParticipationVC", sender: self)
                break
            }
        }
        
        
        
        let refreshAlert = UIAlertController(title: "Hov", message: "Dette er endnu ikke blevet implementeret", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showParticipationVC" {
            let destinationVC = segue.destination as! SpecificEventViewController
            destinationVC.selectedEventTitle = selectedEventTitle
            destinationVC.selectedEventLocation = selectedEventLocation
            destinationVC.selectedEventDescription = selectedEventDescription
            destinationVC.selectedEventDate = selectedEventDate
            destinationVC.selectedOid = selectedEventOwnerID
            destinationVC.selectedEid = selectedEventEid
            destinationVC.selectedImage = selectedEventImage
            destinationVC.username = username
        }
    }
}
