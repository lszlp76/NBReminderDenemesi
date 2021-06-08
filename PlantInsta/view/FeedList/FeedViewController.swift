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
    var downloadedImage = [UIImage]()
    var postCounterValue: String?
    var idArray = [ String ]()
    var choosenPlant : String = ""
    let firestoreDatabase = Firestore.firestore()
    var plantinstaUser = Auth.auth().currentUser?.email!
    
    var feedArray = [FeedPlant]()
    
    var chosenFeed: String = ""
    let dateFormatter = DateFormatter() // timestampi string yapmak için
   
   
    
    
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
        
        
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
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
        
        // bu indirilecek resim
        //downloadedImage.append((cell.feedImage.image ?? UIImage (named: "logo.png"))!)
        
        
       return cell
    
    }
    
   
  
    func makeAlert(title: String, message : String) {
        let alert = UIAlertController(title:title ,message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        self.present(alert, animated: true, completion: nil)
    }
    @IBOutlet weak var feedList: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        feedList.rowHeight = UITableView.automaticDimension
        feedList.estimatedRowHeight = 600
        //FeedView.translatesAutoresizingMaskIntoConstraints = false
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
    
    func saveToDirectory(){
        
     
        
    }
   
    func deleteFeedPlant(id : String,index : Int){
     
        if Int(self.postCounterValue!) != 0 {
            firestoreDatabase.collection(plantinstaUser!).document(choosenPlant)
                .collection("history")
                .document(id)
                .delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    // post sayısının güncellenmesi
                    // Set the "capital" field of the city 'DC'
                    let newPostCounter =  self.firestoreDatabase.collection(self.plantinstaUser!).document(self.choosenPlant)
                    newPostCounter.updateData([
                        "plantPostCount": String((Int(self.postCounterValue!)! - 1))
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    
                }
            }
            self.feedArray.remove(at: index)
            self.idArray.remove(at: index)
            self.feedList.reloadData()
           
        }
        else {
            self.makeAlert(title: "Delete", message: "You have 0 post to delete")
        }
        
 
    }
    func shareFeed(){
        
        let image = UIImage(named: "Image")
                
                // set up activity view controller
                let imageToShare = [ image! ]
                let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
        
        
        
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
                            
                            let id = document.documentID
                            let feed = FeedPlant(comment: comments, date: Date() , image: image)
                            print("Serverdaki id : \(id)")
                            self.feedArray
                                .append(feed)
                            self.idArray.append(id)
                            
                            
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


func getDocumentsDirectory() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory as NSString
}

extension Data {

    /// Data into file
    ///
    /// - Parameters:
    ///   - fileName: the Name of the file you want to write
    /// - Returns: Returns the URL where the new file is located in NSURL
    func dataToFile(fileName: String) -> NSURL? {

        // Make a constant from the data
        let data = self

        // Make the file path (with the filename) where the file will be loacated after it is created
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)

        do {
            // Write the file from data into the filepath (if there will be an error, the code jumps to the catch block below)
            try data.write(to: URL(fileURLWithPath: filePath))

            // Returns the URL where the new file is located in NSURL
            return NSURL(fileURLWithPath: filePath)

        } catch {
            // Prints the localized description of the error from the do block
            print("Error writing the file: \(error.localizedDescription)")
        }

        // Returns nil if there was an error in the do-catch -block
        return nil

    }

}


//5'in devamı ( tableview içindeki eleman tıklanma )
//5 yaratılan yeni özelliği bu viewcontroller a  ekle
extension FeedViewController: TableViewNew {
    func onClickedShare(index: Int) {
        print(" Share \(index) shared!")
        
        //https://stackoverflow.com/questions/35851118/how-do-i-share-files-using-share-sheet-in-ios
        if let url = URL(string: feedArray[index].image),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
            // Convert the image into png image data
            let pngImageData = image.pngData()

            // Write the png image into a filepath and return the filepath in NSURL
            let pngImageURL = pngImageData?.dataToFile(fileName: "SharedByPlantInsta.png")

            // Create the Array which includes the files you want to share
            var filesToShare = [Any]()

            // Add the path of png image to the Array
            filesToShare.append(pngImageURL!)

            // Make the activityViewContoller which shows the share-view
            
            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                   activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                   
                   // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ,UIActivity.ActivityType.mail,UIActivity.ActivityType.postToTwitter]
                   
                   // present the view controller
                   self.present(activityViewController, animated: true, completion: nil)
            
            
           // let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: [])

            // Show the share-view
            //self.present(activityViewController, animated: true, completion: nil)
            
            }
        
       
        
    }
    
    func onClickedDownload(index: Int) {
       
       
        /**
         NSPhotoLibraryAddUsageDescription izini eklemelisin. Yoksa photosa yazamazsın
         nasıl eklenir.
         infoplist ten ekelersin
         sağ tıklayıp, open as source code diyip
         <key>NSPhotoLibraryAddUsageDescription</key>
         <string>Our application needs permission to write photos...</string>
         bu kodu yapıştır
         
         */
        
        // bu kod, resimi url ye onu da dataya çeviriyor
        // let imagestring = String(parsingdata ( xxxxx ) ) bununla veriyi/resimi stringe çeviriyor
        if let url = URL(string: feedArray[index].image),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) {
                
            
            // photos a yazmak için bu kod yeterli.
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            
            let album = CustomPhotoAlbum("PlantInsta")
            album.save(image)
           
            
            }
        
        
        makeAlert(title: "Download", message: "Download completed!\nCheck your PlantInsta Album")
        
       
    }
    
    func onClickedTrash(index: Int) {
        print(" Trash \(idArray[index])deleted!")
        deleteFeedPlant(id: idArray[index],index: index) // veritabanından silme
        
       
        
    }
}
