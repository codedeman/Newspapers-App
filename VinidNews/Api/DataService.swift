//
//  DataService.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class  DataService {
    
    static let instance = DataService()
    
    func getArtice(url:String,completion:@escaping(_ article:[NewsModel])->()) {
        
        AF.request(url).responseJSON { (reponse) in
            DispatchQueue.global(qos: .background).async {
                guard let data = reponse.data else {
                    completion([])
                    return
                }
                do{
                    guard let json  = try? JSON(data: data) else {return}
                    
                    let reponseapi =  json["response"]
                    if let docs  = reponseapi["docs"].array{
                        var newsArray:Array<NewsModel> = []
                        
                        for rec in docs{
                            let new =  self.parseNews(dic: rec)
                            newsArray.append(new)
                        }
                        
                        completion(newsArray)
                    } else {
                        completion([])
                    }
                    
                }catch {
                    completion([])
                }
            }
            
        }
        
    }
    

    
    // parse json manually
       func parseNews(dic:JSON)->NewsModel{
           let title = dic["headline"]["main"].stringValue
           let subtitle = dic["snippet"].stringValue
           let pub_date = dic["pub_date"].stringValue
           let web_url = dic["web_url"].stringValue
           if let media = dic["multimedia"].array{
               var newArr = [NewsModel]()
               for record in media{
                   if let url = record["url"].string{
                       let new = NewsModel(thumnail: url, subtitle: subtitle, pubdate: pub_date, title: title, url: web_url)
                       newArr.append(new)
                       return  new
                   }
               }

           }
           
           return NewsModel(thumnail: "", subtitle: "", pubdate: "", title: "", url: "")
       }
    
    
    
    
}
