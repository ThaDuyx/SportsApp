//
//  BulletinViewController.swift
//  Sportster
//
//  Created by Christoffer Detlef on 08/01/2021.
//

import UIKit

class BulletinViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bulletinTableView: UITableView!
    
    let events: [String] = ["Boldsport", "Cykling", "Skating", "Løb", "Svømning", "Kampsport", "Atletik", "Fitness", "Gymnastik"]
    
    override func viewDidLoad() {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bulletinTableView.
    }
    
    
    
}
