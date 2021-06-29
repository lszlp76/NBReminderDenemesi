//
//  AppDelegate.swift
//  PlantInsta
//
//  Created by ulas özalp on 16.04.2021.
//

import UIKit
import Firebase
import GoogleSignIn

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    /*func sign(_ signIn: GIDSignIn!,
                  didSignInFor user: GIDGoogleUser!,
                  withError error: Error!) {
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                               accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential, completion: { (user, error) -> Void in
                           if error != nil {
                               print("Problem at signing in with google with error : \(error)")
                           } else if error == nil {
                               print("user successfully signed in through GOOGLE! uid:\(Auth.auth().currentUser!.uid)")
                               print("signed in")
                               
                               let firstusage = UserDefaults.standard
                               if firstusage.integer(forKey: "firstUsage") == 1 {
                                   print("onboarding dont start")
                                   let mainStoryBoard = UIStoryboard (name: "Main",bundle: nil)
                                   
                                   self.window?.rootViewController?.performSegue(withIdentifier: "toPlantList", sender: nil)
                               }
                               else {
                                   firstusage.set(1,forKey: "firstUsage")
                                
                                   firstusage.synchronize()
                                   // onboarding pages.
                                   print("onboarding starts")
                                   let mainStoryBoard = UIStoryboard (name: "Main",bundle: nil)
                                   
                                   self.window?.rootViewController?.performSegue(withIdentifier: "toOnboardingView", sender: nil)
                               }
                               
                               
                           }
                       })
            }

            // Post notification after user successfully sign in
            NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
        }
    
*/

    var window: UIWindow?
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
     
         //google sign in için gereken satılar
         GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
         //GIDSignIn.sharedInstance().delegate = self
         
      

//        window?.rootViewController = ViewController.instantiate()
        
        
        
       
                    
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    //Google signin için
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
   
   
}


  
   
 


