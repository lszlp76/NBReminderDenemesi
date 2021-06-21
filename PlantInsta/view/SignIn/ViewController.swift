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
class ViewController: UIViewController, FUIAuthDelegate {

    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user{
            print("you've signed as \(user.uid). Your email is : \(user.email ?? "")")
            self.performSegue(withIdentifier: "toPlantList", sender: nil)
        }
    }
     
    @IBOutlet var signUpButton: UIButton!
    
    func setUpSignInAppleButton() {
      let authorizationButton = ASAuthorizationAppleIDButton()
       
      authorizationButton.translatesAutoresizingMaskIntoConstraints = false
      authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
      authorizationButton.cornerRadius = 10
        view.addSubview(authorizationButton)
      
        NSLayoutConstraint.activate([
            
          //  authorizationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 100),
            authorizationButton.bottomAnchor.constraint(equalTo: continueButton.bottomAnchor,constant: 38),
            authorizationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 11),
        authorizationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -11)
            
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
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
        setUpSignInAppleButton()
        //assignbackground()
        // Do any additional setup after loading the view.
        
        // klavye görülünce field leri yukarı al
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
       
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
                    self.performSegue(withIdentifier: "toPlantList", sender: nil)
                }
            }
            
        } else {
            makeAlert(title :"Sign In Error" , message :"Username/Password Denied!")
        }
    }
}

