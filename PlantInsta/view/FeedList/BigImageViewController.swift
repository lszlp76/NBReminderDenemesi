//
//  BigImageViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 19.04.2021.
//

import UIKit
import SDWebImage

class BigImageViewController: UIViewController {
    var chosenFeed : String = ""
    var name : String = ""
    var chosenplantDate : String = "" // seçilmiş resimin tarihi
    
    @IBOutlet weak var bigImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "\(name)@\(chosenplantDate)"
        bigImage.isUserInteractionEnabled = true
        bigImage.sd_setImage(with: URL(string: chosenFeed))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(self.pinchGesture))
        bigImage.addGestureRecognizer(pinchGesture)
                                                    
       
        
        // Do any additional setup after loading the view.
    }
    
    @objc func pinchGesture(sender: UIPinchGestureRecognizer){
        sender.view?.transform = (sender.view?.transform.scaledBy(x : sender.scale, y: sender.scale))!
        sender.scale = 1.0
        
        
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
