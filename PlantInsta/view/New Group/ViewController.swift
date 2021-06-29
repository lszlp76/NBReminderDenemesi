//
//  ViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 16.04.2021.
//

import UIKit
import Firebase
import FirebaseUI
import AuthenticationServices
import GoogleSignIn
@available(iOS 13.0, *)
class ViewController: UIViewController,UITextFieldDelegate,FUIAuthDelegate {
   
    /*
    class func instantiate() -> ViewController {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let viewController = storyboard.instantiateViewController(withIdentifier: "\(ViewController.self)") as! ViewController

           return viewController
       }

   */
    

    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user{
            print("you've signed as \(user.uid). Your email is : \(user.email ?? "")")
            self.performSegue(withIdentifier: "toPlantList", sender: nil)
        }
    }
  
    @IBOutlet var signUpButton: UIButton!
    
    @available(iOS 13.0, *)
    
    func setUpSignInAppleButton() {
      let authorizationButton = ASAuthorizationAppleIDButton()
       
      authorizationButton.translatesAutoresizingMaskIntoConstraints = false
      authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
      authorizationButton.cornerRadius = 10
        view.addSubview(authorizationButton)
      
        NSLayoutConstraint.activate([
            
          //  authorizationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 100),
            authorizationButton.bottomAnchor.constraint(equalTo: signInButton.bottomAnchor,constant: 38),
            authorizationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25),
        authorizationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25)
            
        ])
     /**
         
         let style: ASAuthorizationAppleIDButton.Style = darkStyle ? .black : .white
                let appleIDButtonType: ASAuthorizationAppleIDButton.ButtonType = signInText ? .signIn : .continue
                let authorizationButton = ASAuthorizationAppleIDButton(type: appleIDButtonType, style: style)
                authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
                authorizationButton.cornerRadius = 10
                authorizationButton.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
                self.addSubview(authorizationButton)
         
         
         */
        
    }
    @objc  func handleLogInWithAppleID (){
        if let authUI = FUIAuth.defaultAuthUI(){
            authUI.providers = [ FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
            
        }
        
    }
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var continueButton: UIButton!
   
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    
    /* background resmi yapmak için*/
    let backgroundImage = UIImage( named: "background")
    var backgroundImageView : UIImageView!
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //GoogleSignIn
       
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
       
        
        /* background bir imageview içinde atıp arka plan yapıyor*/
        backgroundImageView = UIImageView ( frame: view.bounds)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = backgroundImage
        backgroundImageView.center = view.center
        view.addSubview(backgroundImageView)
        self.view.sendSubviewToBack(backgroundImageView)
        
        /*geç e basınca sonraki alana geçme*/
        emailtext.delegate = self
        passwordText.delegate = self
        emailtext.tag = 0
        passwordText.tag = 1
        
        
        
       
        /* ilk kullanım*/
        UserDefaults.standard.removeObject(forKey: "firstUsage")
      
        setUpSignInAppleButton()
        //assignbackground()
        // Do any additional setup after loading the view.
        
        // klavye görülünce field leri yukarı al
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
              if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                 nextField.becomeFirstResponder()
              } else {
                 // Not found, so remove keyboard.
                 textField.resignFirstResponder()
              }
              // Do not add a line break
              return false
         
       }
    
    
    func assignbackground(){
           let background = UIImage(named: "background")

           var imageView : UIImageView!
           imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
           imageView.clipsToBounds = true
           imageView.image = background
           imageView.center = view.center
           view.addSubview(imageView)
           self.view.sendSubviewToBack(imageView)
       }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: self.view.window)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    @IBAction func signUpClicked(_ sender: Any) {
        if emailtext.text != ""  && passwordText.text != ""
        {
            Auth.auth().createUser(withEmail: emailtext.text!, password: passwordText.text!) { (authData, error) in
                if ( error != nil ){
                    self.makeAlert(title : "Sign Up Error",message: error?.localizedDescription ?? "Error")
                }else
                {
                    self.performSegue(withIdentifier: "toPlantList", sender: nil)
                }
                
            }
            
        }else {
            makeAlert(title : "Sign Up Error",message: "Username/Password Denied")
           
        }
       
    }
    
    func makeAlert(title: String, message : String) {
        let alert = UIAlertController(title:title ,message: message, preferredStyle: UIAlertController.Style.alert)
        let okbutton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okbutton)
        self.present(alert, animated: true, completion: nil)
    }
  
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailtext.text != ""  && passwordText.text != ""{
            Auth.auth().signIn(withEmail: emailtext.text!, password: passwordText.text!) { (authdata, error) in
                if ( error != nil ){
                    self.makeAlert(title: "Sign In Error", message: error?.localizedDescription ?? "Error")
                }else{
                    
                    let firstusage = UserDefaults.standard
                    if firstusage.integer(forKey: "firstUsage") == 1 {
                        print("onboarding dont start")
                       
                        
                    }
                    else {
                        firstusage.set(1,forKey: "firstUsage")
                     
                        firstusage.synchronize()
                        // onboarding pages.
                        print("onboarding starts")
                        self.performSegue(withIdentifier: "toOnboardingView", sender: nil)
                    }
                    
                    
                    self.performSegue(withIdentifier: "toPlantList", sender: nil)
                }
            }
            
        } else {
            makeAlert(title :"Sign In Error" , message :"Username/Password Denied!")
        }
    }
}

