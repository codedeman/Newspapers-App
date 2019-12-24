//
//  NewsStream.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

protocol NewsStream :class {
    var news:Observable<NewsModel> {get}
}
protocol MutableItemsStream:NewsStream {
       func fetch(page: Int?, perPage: Int?, query: String?)
}


//class NewsStreamImpl: MutableItemsStream {
//    func fetch(page: Int?, perPage: Int?, query: String?) {
//        <#code#>
//    }
//    
//    var news: Observable<NewsModel>
//    
//    func fetch(page: Int?, perPage: Int?, query: String?) {
//        <#code#>
//    }
//
//
//    private let _items = BehaviorRelay<NewsModel>(value: [])
//
//
//
//    var news: Observable<NewsModel>
//
//
//
//
//}

