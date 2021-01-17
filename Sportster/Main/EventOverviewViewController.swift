//
//  EventOverviewViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 10/01/2021.
//

import UIKit

class EventOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var eventOverviewTableView: UITableView!
    
    override func viewDidLoad() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let refreshAlert = UIAlertController(title: "Hov", message: "Dette er endnu ikke blevet implementeret", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        self.present(refreshAlert, animated: true, completion: nil)
    }
}
