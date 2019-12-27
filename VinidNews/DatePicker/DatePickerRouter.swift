//
//  DatePickerRouter.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol DatePickerInteractable: Interactable,ArticleListener {
    var router: DatePickerRouting? { get set }
    var listener: DatePickerListener? { get set }
}

protocol DatePickerViewControllable: ViewControllable {
    
    func dismiss(viewController: ViewControllable)

    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

@available(iOS 13.0, *)
final class DatePickerRouter: ViewableRouter<DatePickerInteractable, DatePickerViewControllable>, DatePickerRouting {
    
    private var currentChild: ViewableRouting?
    
    private let datePickerBuilder:DatePickerBuildable
    
    private var viewControllers:DatePickerViewControllable
    
    private let articleBuilder:ArticleBuildable

    

    // TODO: Constructor inject child builder protocols to allow building children.
    @available(iOS 13.0, *)
    init(interactor: DatePickerInteractable,
          viewController: DatePickerViewControllable,datePickerBuilder:DatePickerBuildable,articleBuilder:ArticleBuildable) {
        
        self.viewControllers = viewController
        self.datePickerBuilder = datePickerBuilder
        self.articleBuilder = articleBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    
    func cleanupViews() {
        if let currentChild = currentChild {
            viewController.dismiss(viewController: currentChild.viewControllable)
        }
    }
    
    
     func routerToArticle(date:String){
        
        
        let articleItems = articleBuilder.build(withListener: interactor, date: date)
            currentChild =  articleItems
            attachChild(articleItems)
            viewControllers.dismiss(viewController: articleItems.viewControllable)

       }
    
}
