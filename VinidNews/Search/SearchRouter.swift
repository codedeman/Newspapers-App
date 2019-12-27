//
//  SearchRouter.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol SearchInteractable: Interactable {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    

}



final class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {
    private var currentChild: ViewableRouting?
    private var viewControllers:SearchViewControllable
    private let articleBuilder:ArticleBuildable
    private let searchBuilder:SearchBuildable
    
    
    

     init(interactor: SearchInteractable, viewController: SearchViewControllable,articleBuilder:ArticleBuildable,searchBuilder:SearchBuildable) {
        self.viewControllers = viewController
        self.articleBuilder = articleBuilder
        self.searchBuilder = searchBuilder
        super.init(interactor: interactor, viewController: viewController)
        
        interactor.router = self
    }
}
