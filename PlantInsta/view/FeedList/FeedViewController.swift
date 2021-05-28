//
//  FeedViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 19.04.2021.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var plantDate : String?
    var downloadedImage : UIImage?
    var postCounterValue: String?
   
   
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    let now = Date()  // bugünün tarihin alıyor
    let formatter = DateFormatter()  // format belirleyici
    /*
     dateStyle= .full > Sunday, April 25, 2021 at 1:14:20 PM"
     .long > "April 25, 2021 at 1:15:11 PM"
     .medium > "Apr 25, 2021 at 1:15:54 PM"
     .short > 4/25/21, 1:16:22 PM
     isteğe bağlı format için
     ////formatter.dateFormat="dd/MM/yyyy HH:mm"
     */
    
 
    @IBOutlet var FeedView: UIView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.locale = Locale.current

        //let currentDate = formatter.string(from: now)
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        plantDate = formatter.string(from: feedArray[indexPath.row].date)
        cell.dateText.text = formatter.string(from: feedArray[indexPath.row].date)
        cell.commentText.text = feedArray[indexPath.row].comment
        //cell.feedImage.image = UIImage(named: "deneme.png")
        //let transformer = SDImageResizingTransformer(size: CGSize(width: 414, height: 244), scaleMode: .aspectFill)
        cell.feedImage.sd_setImage (with: URL(string: feedArray[indexPath.row].image))//,placeholderImage: nil, context: [.imageTransformer: transformer])
        
       /*
         6 . tableviewnew için yaratılan celldelegate ları çağırıp
         değer vermen lazım.
        */
        //6
        
        cell.cellDelegate = self   // hucre kendisine eşit olsun
        cell.index = indexPath  // index değeri indexpath olsun.
        
        downloadedImage = cell.feedImage.image
        
        
       return cell
    
    }
    
    
    
    
    
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = downloadedImage
        let croppedImage = (currentImage?.getCrop())!
        return tableView.frame.width * croppedImage
    }
  */
     
   
        
    
    var choosenPlant : String = ""
    let firestoreDatabase = Firestore.firestore()
    var plantinstaUser = Auth.auth().currentUser?.email!
    
    var feedArray = [FeedPlant]()
    var chosenFeed: String = ""
    let dateFormatter = DateFormatter() // timestampi string yapmak için


  
    func makeAlert(title: String, message : String) {
        let alert = UIAlertController(title:title ,message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var feedList: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedView.translatesAutoresizingMaskIntoConstraints = false
        print( "Feed deki sayaç değeri : \(self.postCounterValue!)" )
       /*
        let image = FeedCell()
        let img: UIImage?
        img = image.feedImage.image
        
        image.feedImage.frame = CGRect(x: image.feedImage.frame.origin.x, y: image.feedImage.frame.origin.y,
                                       width: img!.size.width, height: img!.size.height);
        
        */
        // ********* Navigation Bar Title ***********
        // udemy 100 nolu ders navigation
        
        
        
        
        let backButton = UIBarButtonItem()
        backButton.title = "My Plants"
       // let rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
      
        let rightButton = UIBarButtonItem(title: "Add New", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(addButton))
        navigationItem.rightBarButtonItem = rightButton
        
        //self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButton
       
        title = choosenPlant
        feedList.delegate = self
        feedList.dataSource = self
        
        getFeedPlant()
       
        // Do any additional setup after loading the view.
    }
   
     
    @objc func addButton() {
       
        self.performSegue(withIdentifier: "toGallery", sender: nil)
        
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGallery"
        {
            let destinationVC = segue.destination as! UploadViewController
            destinationVC.entryFromFeed = self.choosenPlant
            destinationVC.postCountValue = self.postCounterValue
            
            
        }
        if segue.identifier == "toBigImage"
        {
            let destinationVC = segue.destination as! BigImageViewController
            destinationVC.chosenFeed = chosenFeed // resim adresi gidiyor
            destinationVC.name = choosenPlant // resim adı gidiyor
            destinationVC.chosenplantDate = plantDate ?? "oo"
        }
    }
    
    
   
    
    
    func getFeedPlant(){
        firestoreDatabase.collection(plantinstaUser!)
            .document(choosenPlant)
            .collection("history")
            .order(by: "date")
            .getDocuments { (snapshot, error) in
                if error != nil {
                    self.makeAlert(title: "Database Error", message: error?.localizedDescription ?? "DBase Error")
                }else
                {
                    if snapshot?.isEmpty == false && snapshot != nil {
                        for document in snapshot!.documents
                        {let comments = document.get("comment") as! String
                            let date = document.get("date")  as! Timestamp
                            let image = document.get("image") as! String
                            print("Serverdaki tarihi : \(date)")
                            let feed = FeedPlant(comment: comments, date: Date() , image: image)
                            
                            self.feedArray
                                .append(feed)
                            
                            
                        }
                        self.feedList.reloadData()
                    }
                }
            }
        
    }
    
    
    // resmi büyütecek VC ye gidiş yöntemi
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenFeed = feedArray[indexPath.row].image
        
        self.performSegue(withIdentifier: "toBigImage", sender: nil)
    }
    
    
   
}

extension UIImage {
    func getCrop() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}


//5'in devamı ( tableview içindeki eleman tıklanma )
//5 yaratılan yeni özelliği bu viewcontroller a  ekle
extension FeedViewController: TableViewNew {
    func onClickedShare(index: Int) {
        print(" Share \(index) shared!")
    }
    
    func onClickedDownload(index: Int) {
        print(" Download\(index) downloaded!")
    }
    
    func onClickedTrash(index: Int) {
        print(" Trash \(index) deleted!")
    }
}
