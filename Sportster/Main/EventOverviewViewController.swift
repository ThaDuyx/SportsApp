//
//  EventOverviewViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 10/01/2021.
//

import UIKit

class EventOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventOverviewTableView: UITableView!
    
    let events: [String] = ["Mangler 2 til skiferie", "8 til fodboldkamp", "Løbetur om Furesø", "Mountenbike tur", "FCN mod BIF", "Håndbold VM", "Makker til fitten"]
    
    override func viewDidLoad() {
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.events.count
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
        cell.eventNameLabel?.text = events[indexPath.section]
        
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor
        return cell
    }
}
