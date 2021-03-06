//
//  IntroViewContrtoller.swift
//  Sportster
//
//  Created by Christoffer Detlef on 29/09/2020.
//
import Foundation
import UIKit

class InterestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var interestsLabel: UILabel!
    @IBOutlet weak var interestsTableView: UITableView!
    
    let interests: [String] = ["Boldsport", "Cykling", "Skating", "Løb", "Svømning", "Kampsport", "Atletik", "Fitness", "Gymnastik"]
    var selectedInterests: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestsTableView.delegate = self
        interestsTableView.dataSource = self
        interestsTableView.allowsMultipleSelection = true
    
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        //https://stackoverflow.com/a/59463814
        //----------------------------------------
            let titleText = "Interesser_"
            var charIndex = 0.0
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                    self.interestsLabel.text?.append(letter)
                }
                 charIndex += 1
            }
        //----------------------------------------
    }
    
    @IBAction func interestsButton(_ sender: Any) {
        if selectedInterests.isEmpty {
            let refreshAlert = UIAlertController(title: "Mangler interesse", message: "Du har ikke valgt en interesse", preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Prøv igen", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "showLocationVC", sender: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.interests.count
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
        let cell = interestsTableView.dequeueReusableCell(withIdentifier: "interestsCell") as! InterestsCell
        cell.interestsCellLabelText?.text = interests[indexPath.section]
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(rgb:0x2AC0C0)
        cell.selectedBackgroundView = backgroundView

        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.init(rgb:0x2AC0C0).cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedInterests.append(interests[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = selectedInterests.firstIndex(of: interests[indexPath.section]) {
                    selectedInterests.remove(at: index)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LocationViewController
        destinationVC.selectedInterests = selectedInterests
    }
}
