//
//  RootRouter.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable,ArticleListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
    func push(viecontroller:ViewControllable) 
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    
    private let articleBuilder:ArticleBuildable
    private var articleRouting:ViewableRouting?
    
    @available(iOS 13.0, *)
    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         articleBuilder:ArticleBuilder) {
        
        self.articleBuilder = articleBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self

    }
    
    deinit {
        print("denit ")
    }
    

    override func didLoad() {
        super.didLoad()
        routerToArticle()
        
    }
    
    private func routerToArticle(){
        let articleItems = articleBuilder.build(withListener: interactor, date: "")
        self.articleRouting =  articleItems
        attachChild(articleItems)
         let articleVC =  articleItems.viewControllable
        viewController.present(viewController: articleVC)
        
    }
 
}


