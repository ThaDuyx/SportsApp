//
//  TestViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 05/11/2020.
//

import Foundation
import UIKit

class SpecificEventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var participantsTableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    
    let Participants: [String] = ["Simon Andersen, 22", "Christoffer Detlef, 23", "Asama Hayder, 23", "Line Mørup, 22"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        
        joinButton.layer.cornerRadius = 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.Participants.count
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
        cell.participantsLabel?.text = Participants[indexPath.section]
        return cell
    }
}
