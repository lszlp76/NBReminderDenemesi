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
        let bgcolor1 = UIColor( red:217/255, green: 72/255, blue :89/255,alpha: 1)
        let bgcolor2 = UIColor( red: 200/255, green: 89/255, blue : 92/255,alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descFont = UIFont(name: "AvenirNext-Regular",size: 18)!
        let rocket  = UIImage(named: "logo") as UIImage?
        let rocket3 = UIImage(named: "logomor-1") as UIImage?
        let rocket2 = UIImage(systemName: "circle" ) as UIImage?
        return [
            OnboardingItemInfo(informationImage: rocket!,
                                     title: "title",
                                     description: "description",
                                     pageIcon: rocket!,
                                     color: bgcolor2,
                                     titleColor: UIColor.white,
                                     descriptionColor: UIColor.white,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: rocket2!,
                                     title: "sayfa2",
                                     description: "description 2",
                                     pageIcon: rocket2!,
                                     color: bgcolor2,
                                     titleColor: UIColor.white,
                                     descriptionColor: UIColor.white,
                                     titleFont: UIFont(name: "AvenirNext-Bold", size: 24)!,
                                     descriptionFont: UIFont(name: "AvenirNext-Regular", size: 18)!),
            OnboardingItemInfo(informationImage: rocket3!,
                                     title: "sayfa3",
                                     description: "description 3",
                                     pageIcon: rocket3!,
                                     color: bgcolor2,
                                     titleColor: UIColor.white,
                                     descriptionColor: UIColor.white,
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
