//
//  BulletinViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 08/01/2021.
//

import UIKit

class BulletinViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bulletinTableView: UITableView!
    @IBOutlet weak var addEventButton: UIButton!
    
    let events: [String] = ["Boldsport", "Cykling", "Skating", "Løb", "Svømning", "Kampsport", "Atletik", "Fitness", "Gymnastik"]
    
    override func viewDidLoad() {
//Navigationbar settings - Her bliver den vist, med en specifik farve
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.barTintColor = UIColor.init(rgb: 0x1C8E8E)
        navigationController?.navigationBar.isTranslucent = false
        
// Add event button in the bottom of the screen is being made to a circle
        addEventButton.layer.cornerRadius = addEventButton.frame.height/2
        addEventButton.clipsToBounds = true
        
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
        return self.events.count
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
        let cell = bulletinTableView.dequeueReusableCell(withIdentifier: "postCell") as! PostsCell
        cell.bulletinButton?.setTitle(events[indexPath.section], for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Opdate", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            print("Opdate")
            self.performSegue(withIdentifier: "editSegue", sender: ac)
            success(true)
        })
        
        let delete = UIContextualAction(style: .normal, title: "Slet", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            print("Delete")
            success(true)
        })
        
        let overview = UIContextualAction(style: .normal, title: "Liste", handler: { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            print("Overview")
            self.performSegue(withIdentifier: "participantSegue", sender: ac)
            success(true)
        })
        
        edit.image = UIImage(systemName: "square.and.pencil")
        overview.image = UIImage(systemName: "person.3.fill")
        delete.image = UIImage(systemName: "trash")
        edit.backgroundColor = UIColor.init(rgb: 0x1C8E8E)
        overview.backgroundColor = .blue
        delete.backgroundColor = .red
        
        
        let swipe = UISwipeActionsConfiguration(actions: [edit, overview, delete])
        return swipe
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"{
            _ = segue.destination as! EditEventViewController
        }else if segue.identifier == "participantSegue" {
            _ = segue.destination as! ParticipantEventViewController
      }
    }
}
