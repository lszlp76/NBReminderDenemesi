//
//  OnboardingViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 3.06.2021.
//

import UIKit
import paper_onboarding

@available(iOS 13.0, *)
class OnboardingViewController: UIViewController , PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    
    func onboardingItemsCount() -> Int {
        return 3 // 2 sayfa olacak
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgcolor2 = UIColor( red:248/255, green: 187/255, blue :208/255,alpha: 1)
       // let bgcolor1 = UIColor( red: 200/255, green: 89/255, blue : 92/255,alpha: 1)
        
       // let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
       // let descFont = UIFont(name: "AvenirNext-Regular",size: 18)!
        let rocket  = UIImage(named: "pageone") as UIImage?
        let rocket3 = UIImage(named: "pagethree") as UIImage?
        let rocket2 = UIImage(named: "pagetwo" ) as UIImage?
        let icon = UIImage( named: "logo") as UIImage?
        //let fontColor1 = UIColor (red: 206/255, green: 147/255, blue: 216/255, alpha: 1)
        let fontColor2 = UIColor (red: 171/255, green: 71/255, blue: 188/255, alpha: 1)
        
        return [
            OnboardingItemInfo(informationImage: rocket!,
                                     title: "Keep a diary for your plant",
                                     description: "Observe the growth of your seedlings in your garden, the flowers on your balcony, and the plants in your field, photograph them and take some notes.",
                                     pageIcon: icon!,
                                     color: bgcolor2,
                                     titleColor: fontColor2,
                                     descriptionColor: fontColor2,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: rocket2!,
                                     title: "Keep it up to date",
                                     description: "Add pages to your diaries. Follow the growth of your plants with your diaries.",
                                     pageIcon: icon!,
                                     color: bgcolor2,
                                     titleColor: fontColor2,
                                     descriptionColor: fontColor2,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: rocket3!,
                                     title: "Share it !",
                                     description: "Share your pages with your friends.",
                                     pageIcon: icon!,
                                     color: bgcolor2,
                                     titleColor: fontColor2,
                                     descriptionColor: fontColor2,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!)
                
        ] [index]
    }
    @IBOutlet weak var getStartedButton: UIButton!
    
    /*
     onboarding view button eklerken , buttonu ana view e eklemen lazım
     
     https://www.youtube.com/watch?v=G5UkS4Mrepo
     */
    @IBOutlet weak var onboardingViw: OnboardingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingViw.dataSource = self
        onboardingViw.delegate = self
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    func onboardingDidTransitonToIndex(_ index: Int) {
        // eğer 3ncu sayfaya gelirse
        if index == 2{
            
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1
            })
        }
    }
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1{
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
