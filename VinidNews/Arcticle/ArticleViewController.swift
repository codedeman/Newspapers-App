//
//  ArticleViewController.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

import SnapKit
protocol ArticlePresentableListener: ArticleListener {
    func didTapSearchButton()
    func didSelectItem(url:URL)
    func didTapDatePicker()
}

final class ArticleViewController: UIViewController,ArticlePresentable, ArticleViewControllable {
        
   
    
    var date:String!
    
    @IBOutlet weak var dateSelectButton: UIButton!
    
    let resultDefault = BehaviorRelay<[NewsModel]>(value: [])
    @IBOutlet weak var searchButton: UIBarButtonItem!
    private let disposeBag = DisposeBag()
    weak var listener: ArticlePresentableListener?
    @IBOutlet weak var spinerActivity: UIActivityIndicatorView!
    @IBOutlet weak var articleTableViewController: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        articleTableViewController?.register(UINib(nibName: "NewFeed2Cell", bundle: nil), forCellReuseIdentifier: "NewFeed2Cell")
        blindUI()
        


    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CheckInternet.connectInternet(){
            
        }else{
            
            simpleAlert(title: "No Connection Found ", msg: "Please check your network connection")
            
            
        }
        
    }
    
    private func blindUI()
    {
        resultDefault.asObservable().bind(to: self.articleTableViewController.rx.items(cellIdentifier: "NewFeed2Cell", cellType: NewFeedCell.self)){
            (index,new,cell) in
            DispatchQueue.main.async {
                cell.configureCell(data: new)
                self.spinerActivity.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        
        articleTableViewController.rx.modelSelected(NewsModel.self).asDriver().drive(onNext: { (item) in
            
            guard let url = URL(string: item.url) else {return}
            self.listener?.didSelectItem(url: url)
        }).disposed(by: disposeBag)
        
        dateSelectButton.rx.tap.subscribe(onNext: {  [weak self] in
            
            self!.listener?.didTapDatePicker()
            
            }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
       
    }
    
    
    @IBAction func searchButtonWasPressed(_ sender: Any) {
        listener?.didTapSearchButton()
    }
    
    func present(viewController: ViewControllable) {
        navigationController?.present(viewController.uiviewController, animated: false, completion: nil)

    }
    
    func dismiss(viewController: ViewControllable) {
        
        dismiss(animated: false, completion: nil)
    }
    
    func push(viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: false)
    }
    
    
}

extension ArticleViewController:SearchViewControllable{}
