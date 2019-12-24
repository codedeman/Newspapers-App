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

protocol SearchPresentableListener: class {
    func search(with keyword: String)
    func cancelSearch()
    


}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
    func present(viewController: ViewControllable) {
//        present(viewController: viewController.uiviewController)
    }
    
    func dismiss(viewController: ViewControllable) {
//        dismiss(animated: viewController.uiviewController, completion: nil)
    }
    
    var searchInput = Variable<String>("")
    
    var searchResult =  BehaviorRelay<[NewsModel]>(value: [])
    
//    var searchInput =  BehaviorRelay<String>(value: "")
    private let disposeBag = DisposeBag()
    @IBOutlet weak var spinerActivity: UIActivityIndicatorView!
    @IBOutlet weak var searchInputTxt:UITextField!
    @IBOutlet weak var searchResultTable: UITableView!
    weak var listener: SearchPresentableListener?
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTable.register(UINib(nibName: "NewFeed2Cell", bundle: nil), forCellReuseIdentifier: "NewFeed2Cell")
        blindUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.view.backgroundColor = UIColor.red
//        configureUI()

//        searchResultTable.register(UINib(nibName: "NewFeed2Cell", bundle: nil), forCellReuseIdentifier: "NewFeed2Cell")
//               blindUI()
    }
    
    private func configureUI()
    {
        
        self.view.addSubview(searchInputTxt!)
        searchInputTxt!.snp.makeConstraints { (make) in

            make.top.equalTo(view).offset(30)
            make.trailing.equalTo(view).offset(10)
            make.leading.equalTo(view).offset(10)
            make.height.equalTo(40)

        }
        
    }
    
    private func blindUI(){
        
        self.searchInputTxt.rx.text.orEmpty.throttle(.maximum(5, 10), scheduler: MainScheduler.instance).asObservable().bind(to: searchInput).disposed(by: disposeBag)
        
        searchInput.asObservable().subscribe(onNext: { (event) in
            
            self.listener?.search(with: event)
        }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
//        searchInputTxt?.rx.text.subscribe(onNext: { (text) in
//                       if text!.isEmpty{
//                           self.spinerActivity.stopAnimating()
//                       }else{
//                           self.spinerActivity.startAnimating()
//                       }
//
//            }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
            searchResult.subscribe(onNext: {
                print($0)
            }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
        
        searchResult.asObservable().bind(to: self.searchResultTable.rx.items(cellIdentifier: "NewFeed2Cell",cellType: NewFeedCell.self)){
            
            (index,news,cell) in
                      DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        self.spinerActivity.stopAnimating()
                        cell.configureCell(data: news)

                      }
            
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            
            self?.dismiss(animated: false, completion: nil)
            
            
        }).disposed(by: disposeBag)
        
        
    }
}
