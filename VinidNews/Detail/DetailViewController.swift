//
//  DetailViewController.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import WebKit

protocol DetailPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class DetailViewController: UIViewController, DetailPresentable, DetailViewControllable {
    var item: URL!

    weak var listener: DetailPresentableListener?
    @IBOutlet weak var newsPageView: WKWebView!
    @IBOutlet weak var spinnnerActivity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                self.spinnnerActivity.stopAnimating()
                    self.loadNewsPage(url: self.item)
            })
        
    }
    
    func loadNewsPage(url:URL)  {
           do{
               let requestURL = try URLRequest(url: url, method: .get)
                     newsPageView.load(requestURL)
               
           }catch{
               debugPrint("errorr")
           }
         
       }
}
