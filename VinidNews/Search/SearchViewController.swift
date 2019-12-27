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
    var param: BehaviorRelay<ParamSearchArticles>{get set}
    

    


}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
  
    private let disposeBag = DisposeBag()
    @IBOutlet weak var searchResultTable: UITableView!
    weak var listener: SearchPresentableListener?
    private let refreshControl = UIRefreshControl()
    private let loadMoreCell: String = "LoadMoreCell"
    private let newFeedCell:String = "NewFeed2Cell"
    private var indicator: UIActivityIndicatorView!
    private let param: ParamSearchArticles = ParamSearchArticles()
    private let searchController = UISearchController(searchResultsController: nil)
    var result =  BehaviorRelay<[DocsSection]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        blindSearchUI()
        blinData()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CheckInternet.connectInternet(){
            
        }else{
            
            simpleAlert(title: "No Connection Found ", msg: "Please check your network connection")
            
        }
    }
    
    
    private func initTableView(){
        searchResultTable.register(UINib(nibName: newFeedCell, bundle: nil), forCellReuseIdentifier: newFeedCell)
        
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
        if let text = searchController.searchBar.text, !text.isEmpty, text.count > 0 {
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
        
        searchController.searchBar.rx.text.asObservable().debounce(3, scheduler: MainScheduler.asyncInstance).subscribe(onNext: { (event) in
                self.indicator.isHidden = false
                self.onSearch()
                
            }, onError: nil, onCompleted: nil).disposed(by: disposeBag)

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
        
          if let cell = self.searchResultTable.dequeueReusableCell(withIdentifier: newFeedCell) as? NewFeedCell {
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
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


