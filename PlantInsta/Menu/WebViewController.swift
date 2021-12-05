//
//  WebViewController.swift
//  PlantInsta
//
//  Created by ulas özalp on 20.04.2021.
//

import UIKit
import WebKit
import Firebase

class WebViewController: UIViewController , WKNavigationDelegate{
    var chosenlink = 0
    var webView : WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       var link = " "
        switch chosenlink {
        case 0 :
            
          link =  "https://www.agromtek.com/plantInsta.html"
        case 1 :
            
           link = "https://www.agromtek.com/plantInstasozlesme.html"
            
        case 2:
           link =  "https://www.agromtek.com/plantInstailetisim.html"
        case 3:
        link = "https://www.hepsiburada.com/magaza/neseli-bahce"
        
        case 4:
            link =  "https://www.agromtek.com"
           
            
        default:
           link =  "https://www.agromtek.com"
        }
        let url = URL(string : link)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        /*
 web view detayları https://www.hackingwithswift.com/read/4/2/creating-a-simple-browser-with-wkwebview
*/
 
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
