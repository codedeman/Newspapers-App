//
//  NewsDetailVC.swift
//  VinidNews
//
//  Created by Apple on 11/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import WebKit
import RxCocoa
import RxSwift
class NewsDetailVC: UIViewController,WKNavigationDelegate {
   
    @IBOutlet weak var newsPageView: WKWebView!
    @IBOutlet weak var spinnner: UIActivityIndicatorView!
    var web_url:String!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if web_url != nil{
            
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                
                self.spinnner.stopAnimating()

                self.loadNewsPage(urlString: self.web_url)

                
            })
            
        }
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
        
            if CheckInternet.connectInternet(){
                
                
            }else{
                self.showOffline()
                
                
            }

    }
    
    func configureNavigation()
    {

            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
            let backbutton = UIButton(type: .custom)
            backbutton.setTitle("Back", for: .normal)
            backbutton.addTarget(self, action: #selector(backHome), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
            view.addSubview(navBar)
    }
    
    @objc func backHome(){
        navigationController?.popViewController(animated: true)
    }
    
    func sendDataToBack(value: String) {
    }
    
    func webView(_ webView: WKWebView,didStart navigation: WKNavigation!) {
        
        spinnner.startAnimating()
        
      }
      func webView(_ webView: WKWebView,didFinish navigation: WKNavigation!) {
         print("Page loaded")
        spinnner.stopAnimating()
      }
    
    func loadNewsPage(urlString:String)  {
        do{
            guard let url =  URL(string: urlString)  else {return}
            let requestURL = try URLRequest(url: url, method: .get)
                  newsPageView.load(requestURL)
            
        }catch{
            debugPrint("errorr")
        }
      
    }
    

}
