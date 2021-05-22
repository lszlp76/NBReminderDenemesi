//
//  FeedListViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 19.04.2021.
//

import UIKit

class FeedListViewController: UIViewController {
    
    var choosenPlant = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
       // plantnametext.text = choosenPlant
        title = choosenPlant
        // Do any additional setup after loading the view.
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
