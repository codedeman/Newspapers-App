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
    

   
}

final class ArticleViewController: UIViewController,ArticlePresentable, ArticleViewControllable {
    
    
    private let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: nil, action: nil)
    let searchResult = BehaviorRelay<[NewsModel]>(value: [])
    
    
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
    func configureUI()  {
        
        title = "The News York times"
        let navigationItem =  UINavigationItem(title: title!)
        navigationItem.rightBarButtonItem = searchButton

        
//        tableView?.register(UINib(nibName: "NewFeed2Cell", bundle: nil), forCellReuseIdentifier: "NewFeed2Cell")

        let navigationBar  = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        navigationBar.setItems([navigationItem], animated: false)
             self.view.addSubview(navigationBar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchResult.subscribe { (event) in
            print("event \(event)")
        }

        
    }
    
    private func checkEvent(){
        
        if searchResult.value.isEmpty{

        }else{
            
//            articleTableViewController.reloadData()
            blindUI()
        }
    
    }
    
    private func blindUI()
    {
        
        searchResult.asObservable().bind(to: self.articleTableViewController.rx.items(cellIdentifier: "NewFeed2Cell", cellType: NewFeedCell.self)){
            (index,new,cell) in
            DispatchQueue.main.async {
//                cell.descriptionLabel.text = new.pubdate
                cell.configureCell(data: new)
                self.spinerActivity.stopAnimating()
                
            }
        }.disposed(by: disposeBag)
        
    }
    
    
    @IBAction func searchButtonWasPressed(_ sender: Any) {
        
        
        
    }
    
    
}

