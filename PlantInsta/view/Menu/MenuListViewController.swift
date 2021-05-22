//
//  MenuListViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 19.04.2021.
//

import UIKit

import Firebase
import MaterialComponents.MaterialBottomAppBar


class MenuListViewController: UIViewController , UITableViewDelegate,UITableViewDataSource{
    
    var utilitylist = [String]()
    var chosen = 0
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return utilitylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = utilitylist[indexPath.row]
        return cell
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menulist.delegate = self
        menulist.dataSource = self
        
       
        utilitylist.append("How to use ?")
        utilitylist.append("Policies")
        utilitylist.append("Contacts")
        utilitylist.append("Neseli Bahce Workshop")
        utilitylist.append("Log out")
        
    }
    @IBOutlet weak var containerView: UIView!
   
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       chosen = indexPath.row
        
        if chosen != 4 { // logout yapmak için bu şart koyuldu
            self.performSegue(withIdentifier: "toWebView", sender: nil)
        }else
        {
            do {
                try
                Auth.auth().signOut()
                
                self.performSegue(withIdentifier: "toViewController", sender: nil)
                }catch
                {
                    print ("Error")
                }
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView"
        {
            let destinationVC = segue.destination as! WebViewController
            destinationVC.chosenlink = chosen
        }
    }
   
    @IBOutlet weak var menulist: UITableView!
    
        
        
    
    
}
