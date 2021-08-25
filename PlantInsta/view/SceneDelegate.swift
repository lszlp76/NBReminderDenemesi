//
//  SceneDelegate.swift
//  PlantInsta
//
//  Created by ulas özalp on 16.04.2021.
//

import UIKit
import Firebase
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            let board = UIStoryboard (name: "Main", bundle: nil)
            let tabBar = board.instantiateViewController(identifier: "tabBar") as! UITabBarController
            
            
////            let firstusage = UserDefaults.standard
////            if firstusage.integer(forKey: "firstUsage") == 1 {
////                print("onboarding doesnt start")
////                
////                self.window?.rootViewController!.dismiss(animated: true) {
////                    self.window?.rootViewController!.performSegue(withIdentifier: "toPlantList", sender: nil)
////                }
////                
////            }
////            else {
////                firstusage.set(1,forKey: "firstUsage")
////             
////                firstusage.synchronize()
////                // onboarding pages.
////                print("onboarding starts")
////                self.window?.rootViewController!.dismiss(animated: true) {
////                    self.window?.rootViewController!.performSegue(withIdentifier:  "toOnboardingView",sender: nil) //
////                }
////                
//            }
            window?.rootViewController = tabBar // İlk açılacak ekran tabBar olsun
            
            
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
           /*
            let vc1 = UIViewController()
            vc1.view.backgroundColor = UIColor.orange
            vc1.tabBarItem.title = "Orange"
            vc1.tabBarItem.image = UIImage(named: "heart")
            
            // Set up the second View Controller
            let vc2 = UIViewController()
            vc2.view.backgroundColor = UIColor.purple
            vc2.tabBarItem.title = "Red"
            vc2.tabBarItem.image = UIImage(named: "star")
            
            // Set up the Tab Bar Controller to have two tabs
           
            tabBar.viewControllers = [vc1, vc2]
            */
            
     
       
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
      

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

