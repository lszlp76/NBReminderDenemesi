//
//  CustomCameraViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 18.08.2021.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)

class CustomCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate,  UITabBarControllerDelegate,
                                  UIPopoverPresentationControllerDelegate,UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    @IBAction func selectPictures(_ sender: Any) {
       pickImage()
    }
    @IBOutlet weak var pushButton: UIButton!
    
    
    var selectedImage : UIImage!// galeriden seçilen resim olacak
    var entryFromFeed : String!
    var postCountValue: String?
    var imagePickerController: UIImagePickerController?
    
    
    
    @IBOutlet weak var previewView: UIView!
    //@IBOutlet weak var captureImageView: UIImageView!
  
    @IBOutlet weak var buttonStack: UIStackView!
   
   
    @IBAction func didTakePhoto(_ sender: Any) {
        
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
        pushButton.backgroundImage(for: .highlighted)
    }
    
    @IBOutlet weak var previewCameraView: UIView!
    
        
    
    @objc func viewPinched(recognizer : UIPinchGestureRecognizer){
        switch recognizer.state {
        case .began:
            
            recognizer.scale = cameraDevice.videoZoomFactor
        case .changed:
            let scale = recognizer.scale
            print(recognizer.scale)
            print(cameraDevice.activeFormat.videoMaxZoomFactor)
            do {
                try cameraDevice.lockForConfiguration()
                cameraDevice.videoZoomFactor = max ( cameraDevice.minAvailableVideoZoomFactor, min (scale, cameraDevice.maxAvailableVideoZoomFactor))
                cameraDevice.unlockForConfiguration()
            }
            catch {
                print(error)
            }
        default:
            break
        }
    }
    
    
   
    var captureSession : AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    var input : AVCaptureDeviceInput!
    var cameraDevice : AVCaptureDevice!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //zoom yapmak için ekrana çift parmak dokunma
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(viewPinched(recognizer:)))
        previewCameraView.addGestureRecognizer(pinchGesture)
        
        self.tabBarController?.delegate = self
        
        imagePickerController?.delegate = self
        if entryFromFeed != nil {
            title = "Add New Page"
            tabBarController?.tabBar.items![1].isEnabled = false
        }else {
            title = "New Plant"
            tabBarController?.tabBar.items![1].isEnabled = true
        }
        
//        let rightButton = UIBarButtonItem(title: "My Pictures", style: UIBarButtonItem.Style.plain, target: self, action: #selector(pickImage))
//        navigationItem.rightBarButtonItem = rightButton

        //pushButton.layer.zPosition = 5
        //selectPicture.layer.zPosition = 6
        buttonStack.layer.zPosition = 5
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        else {
           print ("Unable to access back camera")
            return
        }
        cameraDevice = backCamera
        do {
            input =  try AVCaptureDeviceInput(device: backCamera)
            // Photo output
             stillImageOutput = AVCapturePhotoOutput()
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        } catch let error {
            print("Error unable to initialze back camera: \(error.localizedDescription)")
        }
       
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.previewView.bounds
        }
    }
    func setupLivePreview(){
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resize
        videoPreviewLayer.connection?.videoOrientation = .portrait
        previewView.layer.addSublayer(videoPreviewLayer)
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo:AVCapturePhoto, error: Error? ) {
        
        guard let imageData = photo.fileDataRepresentation()
        else { return}
        
        let image = UIImage( data: imageData)
        //captureImageView.image = image
        selectedImage = image
        
        self.performSegue(withIdentifier: "toSelectImage", sender: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if entryFromFeed != nil {
            title = "Add New Page"
            tabBarController?.tabBar.items![1].isEnabled = false
            tabBarController?.tabBar.items![1].title = "New Diary"
        }else {
            title = "New Plant"
            tabBarController?.tabBar.items![1].isEnabled = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        tabBarController?.tabBar.items![1].isEnabled = true
        tabBarController?.tabBar.items![1].title = "New Diary"
        
        
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
        picker.dismiss(animated: true)
        
        self.dismiss(animated: true) {
            picker.delegate = nil
            self.imagePickerController = nil
            self.performSegue(withIdentifier: "toSelectImage", sender: nil)
        }
         
        //{
//
//
//             }
      
        
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
}
