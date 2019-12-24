//
//  NewsViewModel.swift
//  VinidNews
//
//  Created by Apple on 11/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class NewsViewModel:NSObject {
    
    
    var searchResult = BehaviorRelay<[NewsModel]>(value: [])
    let resultDefault = BehaviorSubject<String>(value: "")
    private var searchInput =  BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    let obseverbel = Observable.from("")
    private var behaviorSubject = BehaviorRelay<String>(value: "")
    
    
    override init() {
        super.init()
        blindingData()
    }
    
    
    // blinding data
    func blindingData()  {
            
            resultDefault.subscribe(onNext: { (text) in
                let url = BASE_URL+"\(text)"+TOKEN
                self.requestJson(url: url)
            }, onError: nil, onCompleted: nil).dispose()
    
        
            self.searchInput.asObservable().subscribe(onNext: { (text) in
                
                    if text.isEmpty{
                        
                    
                    }else{
                    let url = BASE_URL2+"\(text)"+TOKEN2
                        self.requestJson(url: url)
                    }
                
            }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
                
        
        }
    
    func getBehavior() ->BehaviorRelay<String> {
        return behaviorSubject
    }
    
    var getSearchInput:BehaviorRelay<String>{
        
        return searchInput
    }
    

    func requestJson(url:String)  {
        AF.request(url).responseJSON { (reponse) in
            DispatchQueue.global(qos: .background).async {
                guard let data = reponse.data else {return}
                
                do{
                    guard let json  = try? JSON(data: data) else {return}
                    
                    let reponseapi =  json["response"]
                    
                    
                    if let docs  = reponseapi["docs"].array{
                        var newsArray:Array<NewsModel> = []
                        
                        for rec in docs{
                            
                            let new =  self.parseNews(dic: rec)
                            
                            newsArray.append(new)
                        }
                        self.searchResult.accept(newsArray)
                    }
                    
                }catch {
                    
                    print("Error")
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
