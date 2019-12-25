//
//  ArticleRouter.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol ArticleInteractable: Interactable,SearchListener,DetailListener,DatePickerListener{
    var router: ArticleRouting? { get set }
    var listener: ArticleListener? { get set }
}

protocol ArticleViewControllable: ViewControllable {
    
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    func  push(viewController: ViewControllable)
}

@available(iOS 13.0, *)
final class ArticleRouter: ViewableRouter<ArticleInteractable, ArticleViewControllable>, ArticleRouting {
    func routeToDatePicker() {
        let dateRouter = dateBuilder.build(withListener: interactor)
        attachChild(dateRouter)
        viewController.present(viewController: dateRouter.viewControllable)
    }
    
    func route(url: URL) {
        let router = detailBuilder.build(item: url)
        attachChild(router)
        viewController.push(viewController: router.viewControllable)
            
    }
    

    private let  searchBuilder:SearchBuildable
    
    private let  detailBuilder:DetailBuilder
    
    private var currentChild: ViewableRouting!
    
    private let dateBuilder:DatePickerBuilder
    
    init(interactor: ArticleInteractable, viewController: ArticleViewControllable,searchBuilder:SearchBuildable,detailBuilder:DetailBuilder,dateBuilder:DatePickerBuilder) {
        
        self.searchBuilder = searchBuilder
        self.detailBuilder = detailBuilder
        self.dateBuilder = dateBuilder
        
        super.init(interactor: interactor, viewController: viewController)
        
        interactor.router  = self
        
    }
        
    override func didLoad() {
        super.didLoad()
    }
    
   
   
    func routeToSearch() {
        let router = searchBuilder.build(withListener: interactor)
              attachChild(router)
              viewController.present(viewController: router.viewControllable)
    }
    

  
    
    
    
}
