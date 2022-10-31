//
//  AddTaskViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/29/22.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onAdd(_ sender: Any) {
        print(taskField.text ?? "")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMyTask" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.viewControllers[0] as! ViewController
            
            var newTask = UserTask()
            newTask.name = taskField.text  ?? ""
            
            controller.taskToAdd = newTask
            //print(controller.tasks.count)
           
            //controller.taskToAddName = taskField.text ?? ""
        }
    }

}
