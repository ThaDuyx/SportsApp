//
//  ParticipantEventViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 11/01/2021.
//

import UIKit

class ParticipantEventViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var participantTableView: UITableView!
    
    let Participants: [String] = ["Simon Andersen, 22", "Christoffer Detlef, 23", "Asama Hayder, 23", "Line Mørup, 22"]
    
    override func viewDidLoad() {
        //Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
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
        return self.Participants.count
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
        cell.participantButton?.setTitle(Participants[indexPath.section], for: .normal)
        return cell
    }
}
