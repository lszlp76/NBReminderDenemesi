//
//  CollectionViewCell.swift
//  PlantInsta
//
//  Created by ulas özalp on 12.08.2021.
//

import UIKit
import Firebase
import SDWebImage

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plantDiartName: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageNumber: UILabel!
    
    let firestoreDatabase = Firestore.firestore()
    var plantinstaUser = Auth.auth().currentUser?.email!
    
    var plantlist = [PlantDiary]() //plantdiary
     
    
}
