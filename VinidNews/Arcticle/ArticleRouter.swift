//
//  ArticleRouter.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol ArticleInteractable: Interactable,SearchListener{
    var router: ArticleRouting? { get set }
    var listener: ArticleListener? { get set }
}

protocol ArticleViewControllable: ViewControllable {
    
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class ArticleRouter: ViewableRouter<ArticleInteractable, ArticleViewControllable>, ArticleRouting {
   
    
    

    private var searchBuilder:SearchBuildable! = nil
    private var currentChild: ViewableRouting!
    
    init(interactor: ArticleInteractable, viewController: ArticleViewControllable,searchBuilder:SearchBuildable) {
        
        self.searchBuilder = searchBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router  = self
        
    }
        
        
    
    
    override func didLoad() {
        
        super.didLoad()
        
//        attachOffArticle()
    
    }
    
   
   
    func routeToSearch() {
        let router = searchBuilder.build(withListener: interactor)
              attachChild(router)
              viewController.present(viewController: router.viewControllable)
    }
    
    func route(toItem item: NewsModel) {
           
        
    }
    
    
    
}
