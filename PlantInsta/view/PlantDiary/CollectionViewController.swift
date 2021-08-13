//
//  CollectionViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 12.08.2021.
//

import UIKit
import Firebase
import SDWebImage

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let firestoreDatabase = Firestore.firestore()
    var plantinstaUser = Auth.auth().currentUser?.email!
    
    var plantlist = [PlantDiary]() //plantdiary objelerinden oluşan bir dizi olacak
    
    var filteredPlants = [PlantDiary]()  // arama için oluşacak dizi
    var chosenPlant = ""
    var favoriteState : Bool = false
    var postCounterValue: String?
    var plantToDelete :String? // silinecek olan plant array adı
    var indexToDelete : Int? // silinicek olan plant array indexi
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        getPlantData()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
    }
    
    
    // margin verme
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 25 , left: 15, bottom: 0,right: 5)
    }
//size widhtxheight
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2, height: view.frame.size.width)
    }
    // resimler arası mesafe
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.5
    }
    //alt alta mesafe
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plantlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YYYY"
        // oluşturulan procell in plantcell sınıfına bağlanması
        
        cell.imageView.sd_setImage(with: URL ( string: plantlist[indexPath.item].plantAvatar))
        cell.createdDate.text = plantlist[indexPath.item].plantFirstDate
        cell.plantDiartName.text = plantlist[indexPath.item].plantName
        
        return cell
    }
    /**FİREBASE DATA ALMAK ****/
    func getPlantData() {
        self.plantlist.removeAll()
        firestoreDatabase.collection(plantinstaUser!)
            .order(by: "plantFirstDate", descending: false)
            .addSnapshotListener{ [self]  (snapshot, error) in
                if ( error != nil ){
                    
                    self.makeAlert(title: "Database Error", message: error?.localizedDescription ??  "DBase Error")
                    
                }else {
                    // plantlist disizini boşaltıyor.
                    
                    if snapshot?.isEmpty == false && snapshot != nil {
                        self.plantlist.removeAll()
                       
                        for document in snapshot!.documents {
                            
                            let plantAvatar = document.get("plantAvatar") as! String
                            let plantFirstDate = document.get("plantFirstDate") as! String
                            let plantName = document.get("plantName") as! String
                            let plantPostCount = document.get("plantPostCount") as? String
                            let plantUserMail = document.get("plantUserMail") as! String
                            let plantFavorite : Bool
                                                       if !((document.get("plantFavorite") != nil)){
                                                           plantFavorite = true //(document.get("plantFavorite")) as! Bool
                                                       }else {
                                                          plantFavorite = document.get("plantFavorite") as! Bool
                                                       }
                                                      
                                                       
                            let plantDiary = PlantDiary(plantAvatar: plantAvatar,plantFirstDate: plantFirstDate, plantName: plantName, plantPostCount: plantPostCount!, plantUserMail: plantUserMail , plantFavorite: plantFavorite)
                                                       
                                                       
                            
                            self.plantlist.append(plantDiary)
                          
                            
                            
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        
        
    }
    /** ALERT DİAILOG*****/
    
    func makeAlert(title: String, message : String) {
        let alert = UIAlertController(title:title ,message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        self.present(alert, animated: true, completion: nil)
    }
}
