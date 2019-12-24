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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ArticlePresentable: Presentable {
    var listener: ArticlePresentableListener? { get set  }
//    func announce(winner: PlayerType?, withCompletionHandler handler: @escaping () -> ())

//    func pushData(news:NewsModel,completion: @escaping()->())
    
    var searchResult:BehaviorRelay<[NewsModel]>{get}
//    var searchDefault = PublishRelay<NewsModel>()
}

protocol ArticleListener: class {
    


}

final class ArticleInteractor: PresentableInteractor<ArticlePresentable>, ArticleInteractable, ArticlePresentableListener {
    func didTapSearchButton() {
        
    }
    
    
    
    
   
    

    weak var router: ArticleRouting?
    weak var listener: ArticleListener?
    
    let resultDefault = BehaviorSubject<String>(value: "")
    private var searchInput =  BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    let obseverbel = Observable.from("")
    private var behaviorSubject = BehaviorRelay<String>(value: "")
    
    let newsViewModel = [NewsModel(thumnail: "nndndj", subtitle: "to day is news day", pubdate: "21-2-1989", title: "21=2", url: "1j2kj2j2m"),NewsModel(thumnail: "nndndj", subtitle: "to day is news day", pubdate: "21-2-1989", title: "21=2", url: "1j2kj2j2m"),NewsModel(thumnail: "nndndj", subtitle: "to day is news day", pubdate: "21-2-1989", title: "21=2", url: "1j2kj2j2m"),NewsModel(thumnail: "nndndj", subtitle: "to day is news day", pubdate: "21-2-1989", title: "21=2", url: "1j2kj2j2m") ]
    
    
    
    func getArticle() {
        
        let url = "https://api.nytimes.com/svc/archive/v1/2019/11.json?api-key=pH4PGY4gblvAcFIMKV8x7MixeFUrf1AR"

        DataService.instance.getArtice(url: url) { (article) in
            self.presenter.searchResult.accept(article)
        }
    }
    
    
    
    
   
    
    
    override init(presenter: ArticlePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        
        
    }
    
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        getArticle()

        
        
//        presenter.searchResult.accept(getArticle())


    }

    override func willResignActive() {
        super.willResignActive()
//            getArticle()

        // TODO: Pause any business logic.
    }
}
