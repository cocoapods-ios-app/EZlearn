//
//  ViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/28/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    let cellReuseIdentifier = "cell"
    
    var tasks:[UserTask] = []
    
    var taskToAdd:UserTask? = nil

    @IBOutlet weak var tableView: UITableView!
    
    let defaultValues = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        //defaultValues.set(tasks, forKey: "usersTasks")
        
        if (defaultValues.value(forKey: "usersTasks") != nil) {
            tasks = defaultValues.value(forKey: "usersTasks") as! [UserTask]
        } else {
            defaultValues.set(tasks, forKey: "usersTasks")
        }
        
        if (taskToAdd != nil) {
            var addMyTaskInHere = defaultValues.value(forKey: "usersTasks") as! [UserTask]
            addMyTaskInHere.append(taskToAdd!)
            print(addMyTaskInHere.count)
            //defaultValues.set(addMyTaskInHere, forKey: "usersTasks")
            //tasks.append(taskToAdd!)
            taskToAdd = nil
            tasks = defaultValues.value(forKey: "usersTasks") as! [UserTask]
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TaskTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! TaskTableViewCell
        
        /*
        let getCells = self.tableView.visibleCells as! Array<TaskTableViewCell>
        for aCell in getCells {
            aCell.Grade.text = nil
            aCell.credits.text = nil
        }*/
        
        cell.taskName.text = tasks[indexPath.item].name
        
        //cell.textLabel?.text = tasks[indexPath.item].name
        
        return cell
    }


}

