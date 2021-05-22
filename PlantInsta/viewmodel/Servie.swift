//
//  Servie.swift
//  PlantInsta
//
//  Created by ulas özalp on 27.04.2021.
//

import Foundation
import UIKit

class ServingUtility {
 
    func makeAlert(vc:UIViewController,title: String, message : String) {
        let alert = UIAlertController(title:title ,message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        vc.present(alert, animated: true, completion: nil)
        
        
    }
    
       
}


