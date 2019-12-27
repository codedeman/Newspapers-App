//
//  ArticleBuilder.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol ArticleDependency: Dependency {
    
}

final class ArticleComponent: Component<ArticleDependency> {
    
    let articleView = ArticleViewController()

}

// MARK: - Builder

protocol ArticleBuildable: Buildable {
    func build(withListener listener: ArticleListener,date:String) -> ArticleRouting
}

@available(iOS 13.0, *)
final class ArticleBuilder: Builder<ArticleDependency>, ArticleBuildable{

    override init(dependency: ArticleDependency) {
        super.init(dependency: dependency)
    }

    @available(iOS 13.0, *)
    func build(withListener listener: ArticleListener,date:String) -> ArticleRouting {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let articleViewcontroller =  storyboard.instantiateViewController(identifier: "HomeVC") as?  ArticleViewController else {fatalError("error")}
        
        articleViewcontroller.date = date
        let interactor = ArticleInteractor(presenter: articleViewcontroller)
                let component = ArticleComponent(dependency: dependency)
                interactor.listener = listener
        
        let searchBuilder = SearchBuilder(dependency: component)
        let detailBuilder = DetailBuilder(dependency: component)
        let dateBuilder = DatePickerBuilder(dependency: component)

        return ArticleRouter(interactor: interactor, viewController: articleViewcontroller, searchBuilder: searchBuilder, detailBuilder: detailBuilder, dateBuilder: dateBuilder)
        
        
    
    }
}

//extension ArticleComponent:SearchDependency{
//    var searchViewController: SearchViewControllable {
//        return articleController
//    }
//
//}









