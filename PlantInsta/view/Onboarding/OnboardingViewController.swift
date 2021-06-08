//
//  OnboardingViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 3.06.2021.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController , PaperOnboardingDataSource{
    
    
    func onboardingItemsCount() -> Int {
        return 1 // 2 sayfa olacak
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgcolor1 = UIColor( red:217/255, green: 72/255, blue :89/255,alpha: 1)
        let bgcolor2 = UIColor( red: 200/255, green: 89/255, blue : 92/255,alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descFont = UIFont(name: "AvenirNext-Regular",size: 18)!
        let rocket  = UIImage(named: "logo") as UIImage?
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
                
        ] [index]
    }
    
    
    @IBOutlet weak var onboardingViw: OnboardingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingViw.dataSource = self
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
