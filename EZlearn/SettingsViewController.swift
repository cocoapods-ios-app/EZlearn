//
//  SettingsViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 11/12/22.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var cellReuseIdentifier = "settCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theCell:SettingsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! SettingsTableViewCell
        /*
        print("Count: " + String(tasks.count))
        print(indexPath.row)
        cell.taskName.text = tasks[indexPath.item].name
        cell.goalCell.backgroundColor = hexStringToUIColor(hex: cellColors[Int(tasks[indexPath.item].colorIndex)])
        */
        switch indexPath.item {
        case 0:
            theCell.settingNameLabel.text = "Name"
            theCell.settingValueLabel.text = ">"
        case 1:
            theCell.settingNameLabel.text = "Email"
            theCell.settingValueLabel.text = ">"
        case 2:
            theCell.settingNameLabel.text = "Avatar"
            theCell.settingValueLabel.text = ">"
        case 3:
            theCell.settingNameLabel.text = "Notifications"
            theCell.settingValueLabel.text = ">"
        case 4:
            theCell.settingNameLabel.text = "Completed Tasks"
            theCell.settingValueLabel.text = ">"
        case 5:
            theCell.settingNameLabel.text = "Credits"
            theCell.settingValueLabel.text = ">"
        default:
            print("SettingsViewController: Cell Overload")
        }
        
        return theCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        var theCell = tableView.cellForRow(at: indexPath) as! SettingsTableViewCell
        switch indexPath.item {
        case 0:
            theCell.settingNameLabel.text = "Name"
            theCell.settingValueLabel.text = ">"
        case 1:
            theCell.settingNameLabel.text = "Email"
            theCell.settingValueLabel.text = ">"
        case 2:
            theCell.settingNameLabel.text = "Avatar"
            theCell.settingValueLabel.text = ">"
        case 3:
            theCell.settingNameLabel.text = "Notifications"
            theCell.settingValueLabel.text = ""
        case 4:
            theCell.settingNameLabel.text = "Completed Tasks"
            theCell.settingValueLabel.text = ">"
        case 5:
            theCell.settingNameLabel.text = "Name"
            theCell.settingValueLabel.text = ">"
        default:
            print("SettingsViewController: Cell Overload")
        }*/

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
