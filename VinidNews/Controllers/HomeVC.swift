//
//  HomeVC.swift
//  VinidNews
//
//  Created by Apple on 11/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa
import SwiftyJSON

protocol SendData {
    func sendDataToBack(value: String)
}

class HomeVC: UIViewController,SendBackData{
    
    private let refreshControl = UIRefreshControl()

    
    @IBOutlet weak var spinnner: UIActivityIndicatorView!
    
    @IBOutlet weak var newFeedTableView: UITableView!
    var newsViewModel = NewsViewModel()
    let disposeBag = DisposeBag()
    var viewModel:NewsViewModel!
    
    @IBOutlet weak var dateSelectedButton: UIButton!
    var delegate: SendData?

    override func viewDidLoad() {
        
        dateSelectedButton.customButton()
        dateSelectedButton.setTitle(getCurrentDate(), for: .normal)
        dateSelectedButton.layer.style = .none
        newFeedTableView.backgroundColor = .clear
        newFeedTableView.separatorColor = .clear
        newFeedTableView.estimatedRowHeight = 400
        newFeedTableView.register(UINib(nibName: "NewFeed2Cell", bundle: nil), forCellReuseIdentifier: "NewFeed2Cell")
        blindingUI()
        blindTableViewSelected()
        
        if #available(iOS 10.0, *) {
            newFeedTableView.refreshControl = refreshControl
        } else {
            newFeedTableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshControlDidRefresh), for: .valueChanged)
    }
    
    
    
    @objc func refreshControlDidRefresh(_ control: UIRefreshControl) {
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { (data) in
            
            self.newFeedTableView.reloadData()
            self.refreshControl.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                
                self.refreshControl.endRefreshing()
                self.refreshControl.isHidden = true
            }
            
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        

     }
    
    
    // get current date if date is not selected
    func getCurrentDate()->String
    {
        let date = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let dateString = "\(String(describing: components.year!))/"+"\(String(describing: components.month!))"
        dateSelectedButton.setTitle(dateString, for: .normal)
//        newsViewModel.resultDefault.accept(dateString)
        newsViewModel.resultDefault.asObserver().onNext(dateString)
        return dateString
    
    }
    
    func sendDataToBack(value: String) {
        
        newsViewModel.resultDefault.asObserver().onNext(value)
        spinnner.startAnimating()
        dateSelectedButton.setTitle(value, for: .normal)
    
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //detect network when connect internet 
        
            if CheckInternet.connectInternet(){
                simpleAlert(title: "Hi user", msg: "successfull")
                
            }else{
                self.showOffline()
                
            }
        
    }
    
    @objc func blindingUI()  {
        self.newsViewModel.searchResult.asObservable().bind(to: self.newFeedTableView.rx.items(cellIdentifier: "NewFeed2Cell", cellType: NewFeedCell.self)){
            (index,news,cell) in
            DispatchQueue.main.async {
                self.spinnner.stopAnimating()
                cell.configureCell(data: news)
            }
            
        }.disposed(by: disposeBag)
        self.spinnner.startAnimating()
        
    }
    
   
    
    private func blindTableViewSelected()
        
    {
        newFeedTableView.rx.modelSelected(NewsModel.self).subscribe(onNext: { (data) in
            let pvc = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
            pvc.web_url = data.url
            self.navigationController?.pushViewController(pvc, animated: true)
            
        }).disposed(by: disposeBag)
            
            
            
    }
    

    
    @IBAction func searchButtonWasPressed(_ sender: Any) {
        
        let searchVC  = SearchVC()
        searchVC.modalPresentationStyle = .overCurrentContext

        present(searchVC, animated: true, completion: nil)

    }
    
    @IBAction func dropdownButtonWasPressed(_ sender: Any) {
        
        let pushDateVC = DatePickerVC()
        pushDateVC.modalPresentationStyle = .overCurrentContext
        pushDateVC.modalTransitionStyle = .crossDissolve
        pushDateVC.delegate = self
        present(pushDateVC, animated: true, completion: nil)
        
    }
    

}
