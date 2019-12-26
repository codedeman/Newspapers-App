//
//  SearchViewController.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa
import SnapKit
import RxDataSources



protocol SearchPresentableListener: class {
//    func search(with keyword: String,pageIndex:Int)
    func cancelSearch()
    var param: BehaviorRelay<ParamSearchArticles>{get set}


}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
    
   
    
    func present(viewController: ViewControllable) {
//        present(viewController: viewController.uiviewController)
    }
    
    func dismiss(viewController: ViewControllable) {
            dismiss(animated: false, completion: nil)
//        dismiss(animated: viewController.uiviewController, completion: nil)
    }
    
    var searchInput = Variable<String>("")
    
    var searchResult =  BehaviorRelay<[NewsModel]>(value: [])
    
    private let disposeBag = DisposeBag()
    @IBOutlet weak var searchInputTxt:UITextField!
    @IBOutlet weak var searchResultTable: UITableView!
    weak var listener: SearchPresentableListener?
    private let refreshControl = UIRefreshControl()
    private let loadMoreCell: String = "LoadMoreCell"
    private var indicator: UIActivityIndicatorView!
    private let param: ParamSearchArticles = ParamSearchArticles()
    @IBOutlet weak var cancelButton: UIButton!
    var result =  BehaviorRelay<[DocsSection]>(value: [])

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        blindSearchUI()
        blinData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func initTableView(){
        searchResultTable.register(UINib(nibName: "NewFeed2Cell", bundle: nil), forCellReuseIdentifier: "NewFeed2Cell")
        
        searchResultTable.register(UINib(nibName: loadMoreCell, bundle: nil), forCellReuseIdentifier: loadMoreCell)
        
            searchResultTable.separatorColor = .clear
        searchResultTable.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 16, right: 0)
        indicator = UIActivityIndicatorView.init()
        self.view.addSubview(indicator)
        indicator.snp.makeConstraints { (tbl) in
            tbl.center.equalTo(self.view)
        }
        
        indicator.startAnimating()
        indicator.isHidden = true
        searchResultTable.delegate = self
        
        
        
        if #available(iOS 10.0, *) {
            self.searchResultTable.refreshControl = refreshControl
        } else {
            self.searchResultTable.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshControl.tintColor = UIColor.lightGray

        
        
        
    }
    
    private func blinData(){
        result.asObservable().bind(to: searchResultTable.rx.items(dataSource: dataSource())).disposed(by: disposeBag)
    
    }
    
    private func onSearch()
    {
        if let text = searchInputTxt.text, !text.isEmpty, text.count > 0 {
            param.keyword = text
            param.pageIndex = 0
            self.listener?.param.accept(param)
        }
    }
    
    
    func loadDataDone() {
        
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.indicator.isHidden = true
        }
        
           
    }
    
    
    private func blindSearchUI(){
        
        
        
        searchInputTxt.rx.controlEvent([.editingChanged]).asObservable().throttle(1000, scheduler: MainScheduler.instance).subscribe(onNext: { [unowned self](_) in
                   self.indicator.isHidden = false
                   self.onSearch()
               }).disposed(by: disposeBag)
        

        
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            
            self?.listener?.cancelSearch()
            
            
        }).disposed(by: disposeBag)
        
    }
    
    
    
    @objc func refreshData()  {
        
        param.pageIndex = 0
        self.listener?.param.accept(param)
    }
    
    
    func getLoadMoreCell() -> UITableViewCell {
        if let cell = searchResultTable.dequeueReusableCell(withIdentifier: loadMoreCell) as? LoadMoreCell {
            cell.indicator.startAnimating()
            return cell
        }
        return UITableViewCell()
    }
    
    func getArticlesCell(item: NewsModel) -> UITableViewCell {
        
          if let cell = self.searchResultTable.dequeueReusableCell(withIdentifier: "NewFeed2Cell") as? NewFeedCell {
            cell.configureCell(data: item)
              return cell
          }
          return UITableViewCell()
      }
    
}

extension SearchViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           let arrCellName = NSStringFromClass(cell.classForCoder).components(separatedBy: ".")
           if loadMoreCell.elementsEqual(arrCellName.last ?? "") {
               param.pageIndex += 1
                self.listener?.param.accept(param)
           }
       }
    
    
    
}

extension SearchViewController{
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<DocsSection> {
           return RxTableViewSectionedReloadDataSource<DocsSection>(
               configureCell: { dataSource, table, indexPath, item in
                   if let item = item as? NewsModel {
                        
                       return self.getArticlesCell(item: item)
                   } else {
                       return self.getLoadMoreCell()
                   }
           })
       }

    
}


class ParamSearchArticles: NSObject {
    var keyword: String = ""
    var pageIndex: Int = 0
}

struct DocsSection {
    var items: [Any]
}

extension DocsSection: SectionModelType {
    typealias Item = Any
    init(original: DocsSection, items: [Item]) {
        self = original
        self.items = items
    }
}


