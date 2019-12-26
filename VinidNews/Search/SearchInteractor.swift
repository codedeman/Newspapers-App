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
    
    var result: BehaviorRelay<[DocsSection]> {get set}

    func loadDataDone()

    
}

protocol SearchListener: class {


    
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    
    
    var param: BehaviorRelay<ParamSearchArticles>
    private let queue = DispatchQueue.global(qos: .background)
    private let disposeBag = DisposeBag()
    private let group = DispatchGroup()

    
    
    private var listData: [Any] = []

    
    func cancelSearch() {
        
        
        
        
    }
    
    
    
    
    

    weak var router: SearchRouting?
    weak var listener: SearchListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SearchPresentable) {
        
        param = BehaviorRelay<ParamSearchArticles>.init(value: ParamSearchArticles())
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    
//    func search(with keyword: String,pageIndex:Int) {
//
//            let url = BASE_URL2+"\(keyword)"+TOKEN2+"&page=2"
//            DataService.instance.getArtice(url: url) { (article) in
//                self.presenter.searchResult.accept(article)
//            }
//
//
//
//
//    }
    private func fetchData(){
        
        
        param.asObservable().subscribe(onNext: { (param) in
            
            print(param.keyword)
            
//            let url = BASE_URL2+"\(param.keyword)"+TOKEN2+"&page=\(param.pageIndex)"
            let url = "https://api.nytimes.com/svc/search/v2/articlesearch.json?q=\(param.keyword)&api-key=pH4PGY4gblvAcFIMKV8x7MixeFUrf1AR&page=\(param.pageIndex)"

            DataService.instance.getArtice(url: url) { (data) in
                
                self.presenter.loadDataDone()
                self.getData(data: data, pageIndex: param.pageIndex)
                
                print("url \(url)")
            }
//
            }).disposed(by: disposeBag)
        
    }
    
    func getData(data:[NewsModel],pageIndex:Int)  {
        
        
        print("data count \(data.count)")
        
        self.queue.sync {
            
            self.group.enter()
            if pageIndex == 0 { self.listData.removeAll() }
            let itemLoadMore: String = "loadmore"
            if let item = self.listData.last as? String, item.elementsEqual(itemLoadMore) {
                          self.listData.removeLast()
            }
            
            self.listData.append(contentsOf: data)
            
            self.listData.append(contentsOf: data)
            
            if data.count >= 10 {
                self.listData.append(itemLoadMore)
            }
            self.group.leave()
            
            
        }
        
        self.group.notify(queue: .main) {
            
            let oneSection = DocsSection(items: self.listData)
            self.presenter.result.accept([oneSection])
        }
        
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        fetchData()
        
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
