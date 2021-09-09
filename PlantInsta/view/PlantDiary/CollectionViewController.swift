//
//  CollectionViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 12.08.2021.
//

import UIKit
import Firebase
import SDWebImage

@available(iOS 13.0, *)
class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
                                UISearchBarDelegate, UISearchResultsUpdating, UITabBarControllerDelegate {
    
  
    
    
    let firestoreDatabase = Firestore.firestore()
    var plantinstaUser = Auth.auth().currentUser?.email!
    
    var plantlist = [PlantDiary]() //plantdiary objelerinden oluşan bir dizi olacak
    
    var filteredPlants = [PlantDiary]()  // arama için oluşacak dizi
    var chosenPlant = ""
    var favoriteState : Bool = false
    var postCounterValue: String?
    var plantToDelete :String? // silinecek olan plant array adı
    var indexToDelete : Int? // silinicek olan plant array indexi
    /*** search METODU */
    let searchPlant = UISearchController()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Plant Diaries"
        collectionView.delegate = self
        collectionView.dataSource = self
        initSearchController()
        // view.addSubview(collectionView)
        getPlantData()
        
        self.tabBarController?.delegate = self
        tabBarController?.tabBar.items![1].isEnabled = true
        //Long Press
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.8 // saniye olarak süre
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    
    // margin verme
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 5, left: 5, bottom: 5,right: 5)
    }
    //size widhtxheight
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
       let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
       let size:CGFloat = (view.frame.size.width-space) / 2.0
       return CGSize(width: size, height: view.frame.size.width-90)
//
//
//        //return CGSize(width: (view.bounds.width/2) , height: view.frame.size.width)
    }
//    // resimler arası mesafe
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 2
//    }
//    //alt alta mesafe
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (searchPlant.isActive){
            return filteredPlants.count
        }
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
        
        if (searchPlant.isActive)
        {
            cell.imageView.sd_setImage(with: URL (string: filteredPlants[indexPath.row].plantAvatar))
            cell.createdDate.text = filteredPlants[indexPath.row].plantFirstDate
            cell.plantDiartName.text = filteredPlants[indexPath.row].plantName
            cell.PostCountLabel    .text = " \(String(filteredPlants[indexPath.row].plantPostCount)) pages"
            self.postCounterValue = String(filteredPlants[indexPath.row].plantPostCount)
            if filteredPlants[indexPath.row].plantFavorite  == true {
                cell.addTofav.setImage(UIImage(systemName: "star.fill"), for: .normal)
                       }else {
                        cell.addTofav.setImage(UIImage(systemName: "star"), for: .normal)
                       }

        }
        else{
            cell.imageView.sd_setImage(with: URL (string: plantlist[indexPath.row].plantAvatar))
            cell.createdDate.text = plantlist[indexPath.row].plantFirstDate
            cell.plantDiartName.text = plantlist[indexPath.row].plantName
            
            if Int(self.plantlist[indexPath.row].plantPostCount)! > 1
            {
                let word = "pages"
                cell.PostCountLabel.text = "\(String(plantlist[indexPath.row].plantPostCount)) \(word)"
            }
            else if Int(self.plantlist[indexPath.row].plantPostCount)! == 1
            {
                let word = "page"
                cell.PostCountLabel.text = "\(String(plantlist[indexPath.row].plantPostCount)) \(word)"
            } else  {
                cell.PostCountLabel.text = "No page in this diary !"
                
                cell.contentView.backgroundColor = UIColor( red: 207/255, green: 216/255, blue : 220/255, alpha:1)
                //cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14)
                
            }
            if plantlist[indexPath.row].plantFavorite == true {
                cell.addTofav.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        }else {
                            cell.addTofav.setImage(UIImage(systemName: "star"), for: .normal)
                        }

            
            self.postCounterValue = String(plantlist[indexPath.row].plantPostCount)
        }
     
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (searchPlant.isActive){
            chosenPlant = filteredPlants[indexPath.row].plantName
            postCounterValue = (filteredPlants[indexPath.row].plantPostCount)
            favoriteState = filteredPlants[indexPath.row].plantFavorite
            self.performSegue(withIdentifier: "toFeedList", sender: nil)
        }
        else{
            chosenPlant = plantlist[indexPath.row].plantName
            postCounterValue = (plantlist[indexPath.row].plantPostCount)
            favoriteState = plantlist[indexPath.row].plantFavorite
            self.performSegue(withIdentifier: "toFeedList", sender: nil)
        }
        
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFeedList"
        {
            if (searchPlant.isActive){
                let destinationVC1 = segue.destination as! FeedViewController // önce yol göster burada as! ile cast ediyorsun
                destinationVC1.choosenPlant = chosenPlant
                destinationVC1.favoriteState = favoriteState
                destinationVC1.postCounterValue = postCounterValue
            }else {
                let destinationVC1 = segue.destination as! FeedViewController // önce yol göster burada as! ile cast ediyorsun
                destinationVC1.choosenPlant = self.chosenPlant
                destinationVC1.favoriteState = favoriteState
                // burada destinationVC ye 2nci viewcontroller uzerindeki tüm elemanları getirir. myName 2nci viewcontroller uzerindeki text yazılacak değişken.
                destinationVC1.postCounterValue = postCounterValue
                
            }
        }
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
    
    func makeAlert(title: String, message : String) {
        let alert = UIAlertController(title:title ,message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        self.present(alert, animated: true, completion: nil)
    }
                

    /****SEARCH BAR *******/
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!
        
        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
        
    }
    
    
    
    // https://www.youtube.com/watch?v=DAHG0orOxKo
    func filterForSearchTextAndScopeButton ( searchText: String , scopeButton : String = "All"){
        if (scopeButton != "Favorites") {
            filteredPlants = plantlist.filter
            
           
            
            { plant in
                
                
                
                   let  scopeMatch = (scopeButton == "All")
                    if ( searchPlant.searchBar.text != "")
                    {
                        let searchTextMatch = plant.plantName.lowercased().contains(searchText.lowercased())
                        return searchTextMatch && scopeMatch
                    }
                    
                    else
                    {
                        
                        return true
                    }
                }
        }else
        { print ("bookmark")
            
            filteredPlants = plantlist.filter
            
            { plant in
                
            
                let  scopeMatch = (scopeButton == "Favorites" && plant.plantFavorite == true)
                    if ( searchPlant.searchBar.text != "" )
                    {
                        let searchTextMatch = plant.plantName.lowercased().contains(searchText.lowercased() )
                        
                        return searchTextMatch && scopeMatch
                    }
                    
                    else
                    {
                        // bookmarkları döndürmek için
                        
                        return scopeMatch
                    }
                }
            
            
            
            
        }
        
        
        
            
       
        self.collectionView.reloadData()
    }
    
    
    func initSearchController(){
        searchPlant.loadViewIfNeeded()
        searchPlant.searchResultsUpdater = self
        searchPlant.obscuresBackgroundDuringPresentation = false
        searchPlant.searchBar.enablesReturnKeyAutomatically = false
        searchPlant.searchBar.returnKeyType = UIReturnKeyType.done
        
        definesPresentationContext = true
        
        //searchPlant.searchBar.placeholder = "ara"
       
            searchPlant.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search My Plants...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
       
        searchPlant.searchBar.barStyle = .black
        navigationItem.searchController = searchPlant
        navigationItem.hidesSearchBarWhenScrolling = false
        searchPlant.searchBar.scopeButtonTitles = ["All","Favorites"]
        searchPlant.searchBar.delegate = self
        
    }
    
//  /**LONG PRESS METODU ******/
//
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {

        let p = longPressGesture.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        print("index path \(String(describing: indexPath)) row at \(p)")
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if longPressGesture.state == UIGestureRecognizer.State.began {
            print("Long press on row, at \(indexPath!.row)")

            if (searchPlant.isActive){
                plantToDelete = filteredPlants[indexPath!.row].plantName

                //filtre edilen isimi ,plantlist içinde olduğu index numarasını buluyor

               let filteredIndex = plantlist.firstIndex(where: { $0.plantName.hasPrefix(filteredPlants[indexPath!.row].plantName)
                })!
                do { try! indexToDelete = filteredIndex

                }

            }else {
                plantToDelete = plantlist[indexPath!.row].plantName
                indexToDelete = indexPath?.row
                print("\(plantlist[indexPath!.row].plantName)")
            }

            makeDeleteAlert(title: "Plant deleting", message: "\(plantToDelete!) diary will delete...")
        }
    }
    func makeDeleteAlert(title: String, message : String) {
        let alert = UIAlertController(title:title ,message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
            //print ("OK pressed")
            self.deletePlant(planttodelete: self.plantToDelete!, index: self.indexToDelete! )

        } )
        let nokbutton = UIAlertAction(title:"No",style: UIAlertAction.Style.default,handler: { action in
            //print ("NOK pressed")
        })
        alert.addAction(okbutton)
        alert.addAction(nokbutton)

        self.present(alert, animated: true, completion: nil)
    }
    func deletePlant(planttodelete: String,index : Int){


        firestoreDatabase.collection(plantinstaUser!)
            .document(planttodelete)
            .delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Deleted!")


                }
            }
        self.plantlist.remove(at: index)

        searchPlant.searchBar.text = "" // search bar 'ı boş karakter tanımlayıp tüm listeyi göstermek için

        self.collectionView.reloadData()


    }
    func favoriteAdjustment(index: Int ){
        if (searchPlant.isActive){

            if plantlist[index].plantFavorite == false {
                firestoreDatabase.collection(plantinstaUser!)
                    .document(plantlist[index].plantName)
                    .updateData( [ "plantFavorite" : true])
                self.collectionView.reloadData()
            }else {
                firestoreDatabase.collection(plantinstaUser!)
                    .document(plantlist[index].plantName)
                    .updateData( [ "plantFavorite" : false])
                self.collectionView.reloadData()
            }


        }

        else{
        if plantlist[index].plantFavorite == false {
            firestoreDatabase.collection(plantinstaUser!)
                .document(plantlist[index].plantName)
                .updateData( [ "plantFavorite" : true])

        }else {
            firestoreDatabase.collection(plantinstaUser!)
                .document(plantlist[index].plantName)
                .updateData( [ "plantFavorite" : false])
        }
        }

    }

    
}

        
     


