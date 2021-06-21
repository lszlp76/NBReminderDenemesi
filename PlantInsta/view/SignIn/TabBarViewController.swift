//
//  TabBarViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 23.04.2021.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBOutlet var tab: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let tabBarItem1 = UITabBarItem(title: "Home", image: UIImage(named: "Home"), tag: 0)
                let tabBarItem2 = UITabBarItem(title: "Messages", image: UIImage(named: "Email"), tag: 1)
                let tabBarItem3 = UITabBarItem(title: "Favorites", image: UIImage(named: "Cake"), tag: 2)
                tabBarItem3.selectedImage = UIImage(named: "Favorite")
        // Do any additional setup after loading the view.
        */
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "American Typewriter", size: 20)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.orange
        vc1.tabBarItem.title = "Orange"
      //  tabBar.barTintColor = UIColor.blue
        
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
