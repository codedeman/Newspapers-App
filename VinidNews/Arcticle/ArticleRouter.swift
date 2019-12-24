//
//  ArticleRouter.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol ArticleInteractable: Interactable,ArticleListener{
    var router: ArticleRouting? { get set }
    var listener: ArticleListener? { get set }
}

protocol ArticleViewControllable: ViewControllable {
    
//    func present(viewController: ViewControllable)
//    func dismiss(viewController: ViewControllable)
}

final class ArticleRouter: ViewableRouter<ArticleInteractable, ArticleViewControllable>, ArticleRouting {

    private let articleBuilder:ArticleBuildable? = nil
    private var currentChild: ViewableRouting?


    override func didLoad() {
        
        super.didLoad()
        
//        attachOffArticle()
    
    }
    
    private func attachOffArticle(){

        let article = articleBuilder!.build(withListener: interactor)
        self.currentChild = article
//        attachChild(article)
//        viewController.present(viewController: article.)


    }
    
}
