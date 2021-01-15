//
//  ParticipantEventViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 11/01/2021.
//

import UIKit
import FirebaseFirestore

class ParticipantEventViewController: ViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate  {

    
    
    @IBOutlet weak var participantTableView: UITableView!
    var selectedEvent: UserEventList = UserEventList(eid: "", title: "")!
    var participantsList = [Participant]()
    var selectedParticipantID: String = ""
    let dbRef = Firestore.firestore()
    
    override func viewDidLoad() {
        //Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
        dbRef.collection("event").document(selectedEvent.eid).collection("participants").addSnapshotListener { (pInfo, error) in
            if error != nil {
                print("Something went wrong: Retrieving particiant data")
                print(error?.localizedDescription ?? "Cannot fetch error")
            } else {
                pInfo?.documentChanges.forEach({ (change) in
                    
                    if change.type == .added {
                        let addedData = change.document.data()
                        let pname = addedData["name"] as! String
                        let pstatus = addedData["status"] as! Bool
                        let pid = addedData["pid"] as! String
                        self.participantsList.append(Participant(pid: pid, name: pname, status: pstatus)!)
                        DispatchQueue.main.async {
                            self.participantTableView.reloadData()
                        }
                    }
                    
                    if change.type == .modified {
                        let modifiedData = change.document.data()
                        for participant in self.participantsList{
                            if modifiedData["pid"] as! String == participant.pid{
                                participant.status = modifiedData["status"] as! Bool
                                DispatchQueue.main.async {
                                    self.participantTableView.reloadData()
                                }
                            }
                        }
                    }
                    
                    if change.type == .removed {
                        let removedData = change.document.data()
                        let removedPid = removedData["pid"] as! String
                        self.participantsList.removeAll{ $0.pid == removedPid}
                        DispatchQueue.main.async {
                            self.participantTableView.reloadData()
                            print("Success: Removed event")
                        }
                    }
                })
            }
        }
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.participantsList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
        let cell = participantTableView.dequeueReusableCell(withIdentifier: "participantCell") as! EventParticipantsCell
        cell.participantButton?.setTitle(participantsList[indexPath.section].name, for: .normal)
        if participantsList[indexPath.section].status == true{
            cell.participantButton.setTitleColor(UIColor.init(rgb: 0x1C8E8E), for: .normal)
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //selectedParticipantID = participantsList[indexPath.section].pid
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showParticipantProfile"{
            let destinationVC = segue.destination as! OwnerProfileViewController
            destinationVC.oid = selectedParticipantID
        }
    }
    
    func pProfileTapped(cell: EventParticipantsCell) {
        let indexPath = self.participantTableView.indexPath(for: cell)
        selectedParticipantID = participantsList[indexPath!.section].pid
        performSegue(withIdentifier: "showParticipantProfile", sender: self)
    }

    func pAcceptTapped(cell: EventParticipantsCell) {
        let indexPath = self.participantTableView.indexPath(for: cell)
        selectedParticipantID = participantsList[indexPath!.section].pid
        self.dbRef.collection("event").document(selectedEvent.eid).collection("participants").document(selectedParticipantID).updateData(["status" : true])
    }
    
    func pDeclineTapped(cell: EventParticipantsCell) {
        let indexPath = self.participantTableView.indexPath(for: cell)
        selectedParticipantID = participantsList[indexPath!.section].pid
        self.dbRef.collection("event").document(selectedEvent.eid).collection("participants").document(selectedParticipantID).delete()
    }
    
}
