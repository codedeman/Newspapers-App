//
//  SearchInteractor.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

protocol SearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    
    var searchInput:Variable<String>{get}
    var searchResult:BehaviorRelay<[NewsModel]> {get}
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)

}

protocol SearchListener: class {
//    var searchResult:BehaviorRelay<[NewsModel]> {get}

    
    
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    func cancelSearch() {
        
        
    }
    
    
    
    func search(with keyword: String) {
        
        print("i \(keyword)")
        
        
       if keyword != nil{
        
            let url = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=\(keyword)&api-key=pH4PGY4gblvAcFIMKV8x7MixeFUrf1AR"
//                BASE_URL+"\(keyword)"+TOKEN
            DataService.instance.getArtice(url: url) { (article) in
                self.presenter.searchResult.accept(article)
            }
        
        }

//
        
    }
    

    weak var router: SearchRouting?
    weak var listener: SearchListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    private func fetchData(){
        
        
        
        
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
