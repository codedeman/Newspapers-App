//
//  ArticleInteractor.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

protocol ArticleRouting: ViewableRouting {
    
    func routeToSearch()
    func route(url:URL)
    func routeToDatePicker()


    
}

protocol ArticlePresentable: Presentable {
    var listener: ArticlePresentableListener? { get set  }

    var resultDefault:BehaviorRelay<[NewsModel]>{get}
}

protocol ArticleListener: class {

    

}

final class ArticleInteractor: PresentableInteractor<ArticlePresentable>, ArticleInteractable, ArticlePresentableListener {
   
    
    func didSelectDate(date: String) {
        let url = BASE_URL+"\(date)"+TOKEN
        
        DataService.instance.getArtice(url: url) { (article) in
            self.presenter.resultDefault.accept(article)
        }

        
    }
    
    func getDate(date: String) {
        print("date ssss \(date)")
    }
    
    func didTapDatePicker() {
        router?.routeToDatePicker()
    }
    
    func didSelectItem(url: URL) {
        
        router?.route(url: url)
    }
    
    
    
   
    
    weak var router: ArticleRouting?
    weak var listener: ArticleListener?
    
    let resultDefault = BehaviorSubject<String>(value: "")
    private var searchInput =  BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    let obseverbel = Observable.from("")
    private var behaviorSubject = BehaviorRelay<String>(value: "")
    
    
    func getArticle() {
        let url = "https://api.nytimes.com/svc/archive/v1/2019/11.json?api-key=pH4PGY4gblvAcFIMKV8x7MixeFUrf1AR"

        DataService.instance.getArtice(url: url) { (article) in
            self.presenter.resultDefault.accept(article)
        }
    }
    
   
     func didTapSearchButton() {
        router?.routeToSearch()
    
    }
    
//   func didSelectItem(_ item: NewsModel?) {
//
//    router?.route(toItem: item!)
//    }
    
        
 
    override init(presenter: ArticlePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        
        
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        getArticle()

    

    }

    override func willResignActive() {
        super.willResignActive()
//            getArticle()

        // TODO: Pause any business logic.
    }
}
