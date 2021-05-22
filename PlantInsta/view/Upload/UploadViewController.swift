//
//  UploadViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 19.04.2021.
//

import UIKit
/*
 kamera için
 https://www.ioscreator.com/tutorials/take-photo-ios-tutorial
 */
class UploadViewController: UIViewController,UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {  //2

    var imagePickerController: UIImagePickerController?
   
    
    var selectedImage : UIImage!// galeriden seçilen resim olacak
    var entryFromFeed : String!
    var postCountValue: String?
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var cameraContainerView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        //addImagePickerToContainerView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      // camera preview yapmak için
        
        //addImagePickerToContainerView()
        
       
       
        let rightButton = UIBarButtonItem(title: "My Pictures", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(pickImage))
        navigationItem.rightBarButtonItem = rightButton
        
    }
    
    func addImagePickerToContainerView(){

        imagePickerController = UIImagePickerController()
       
        
        
        if UIImagePickerController.isCameraDeviceAvailable( UIImagePickerController.CameraDevice.front) {
                imagePickerController?.delegate = self
            imagePickerController?.sourceType = UIImagePickerController.SourceType.camera

                //add as a childviewcontroller
            addChild((imagePickerController!))

                // Add the child's View as a subview
            self.cameraContainerView.addSubview((imagePickerController?.view)!)
            imagePickerController?.view.frame = cameraContainerView.bounds
            imagePickerController?.allowsEditing = false
            imagePickerController?.showsCameraControls = true
            imagePickerController?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            }
        }
    /*
    @IBAction func catchit(_ sender: Any) {
        
       
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
          
            imagePickerController?.takePicture()
            
        }
        }
    */
    /*
  
    Galeri AÇMA****************************
    */
   @objc func pickImage() {
        
        
        if self.imagePickerController != nil {
                   self.imagePickerController?.delegate = nil
                   self.imagePickerController = nil
               }
        
      
        //***photo Album açılışı
        self.imagePickerController = UIImagePickerController.init()
        
        
        let alert = UIAlertController.init(title: "Select Source Type", message: nil, preferredStyle: .actionSheet)
        
        //İpad lerde alertdialog için bu kodu kullan
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {

                if let popoverPresentationController = alert.popoverPresentationController {
                    
                    popoverPresentationController.sourceView = self.view
                    popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    
                    popoverPresentationController.permittedArrowDirections = []

                }

        }
        
        
        /*camera var ise
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { (_) in
                self.presentImagePicker(controller: self.imagePickerController!, source: .camera)
            }))
        }*/
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(UIAlertAction.init(title: "Photo Library", style: .default, handler: { (_) in
               
                self.presentImagePicker(controller: self.imagePickerController!, source: .photoLibrary)
            }))
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            alert.addAction(UIAlertAction.init(title: "Saved Albums", style: .default, handler: { (_) in
                self.presentImagePicker(controller: self.imagePickerController!, source: .savedPhotosAlbum)
            }))
        }
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    
      
       
    }
     
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            // eğer seçilen image orijinal değil ise cancel et.
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else {
                return self.imagePickerControllerDidCancel(picker)
            }
           
            
        selectedImage = image
    
     
         picker.dismiss(animated: true) {
                 picker.delegate = nil
                 self.imagePickerController = nil
             }
        
        
        
      
        self.performSegue(withIdentifier: "toSelectImage", sender: nil)
        }
   
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                picker.delegate = nil
                self.imagePickerController = nil
            }
        }
    
        internal func presentImagePicker(controller: UIImagePickerController , source: UIImagePickerController.SourceType) {
            controller.delegate = self
            controller.sourceType = source
            self.present(controller, animated: true)
        }
 
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
             if segue.identifier == "toSelectImage"
             {
                 
                 let destinationVC = segue.destination as! SelectImageViewController
                 destinationVC.selectImage = selectedImage
                destinationVC.entryFromFeed = self.entryFromFeed
                destinationVC.postCountValue = self.postCountValue
                
             }
         
         
     }
   
   
    }

