//
//  Extension.swift
//  VinidNews
//
//  Created by Apple on 11/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
let imageCache = NSCache<NSString, AnyObject>()
let manager = NetworkReachabilityManager(host: "https://www.nytimes.com")
extension UIImageView {
    // load image using cache
    func loadImageUsingCache(withUrl urlString : String) {
        guard let url = URL(string: urlString) else {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }

        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }

        }).resume()
    }
}

extension UIViewController{


    func simpleAlert(title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
//    func checkInternet(){
//
//            manager?.startListening(onQueue: .global(), onUpdatePerforming: { (status) in
//
//                    switch status{
//                    case .reachable(_):
////                        self.simpleAlert(title: "Kết nối internet ", msg: "Dẹp trai")
//                        break
//                    case.notReachable:
//                        self.showOffline()
//                        break
//                    case .unknown:
////                        self.simpleAlert(title: "Can not load", msg: "please check your internet")
//                        break
//
//                    }
//
//                })
//
//
//    }
//
    func showOffline()  {
    
        DispatchQueue.main.async {
            
            let offlineVC = OfflineViewController()
                
            
            self.present(offlineVC, animated: true, completion: nil)
            
        }
    }
    
 
}
extension UIButton{


    func customButton()
    {
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
    }

}


//
