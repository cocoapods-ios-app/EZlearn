//
//  HomeNavViewController.swift
//  EZlearn
//
//  Created by Sharonda Daniels on 10/30/22.
//

import UIKit

class HomeNavViewController: UINavigationController, UINavigationBarDelegate, UIBarPositioningDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.delegate = self


        // Do any additional setup after loading the view.
    }
    

    func position(for bar: UIBarPositioning) -> UIBarPosition {
     return .topAttached
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
