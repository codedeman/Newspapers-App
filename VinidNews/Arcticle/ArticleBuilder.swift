//
//  ArticleBuilder.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol ArticleDependency: Dependency {
    
    var articleViewController:ArticleViewControllable {get}
}

final class ArticleComponent: Component<ArticleDependency> {
    
    
    let articleController:ArticleViewController! = nil
    
//    override init(dependency: Dependency) {
//        super.init(dependency: dependency)
//        
//    }

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol ArticleBuildable: Buildable {
    func build(withListener listener: ArticleListener) -> ArticleRouting
}

@available(iOS 13.0, *)
final class ArticleBuilder: Builder<ArticleDependency>, ArticleBuildable{

    override init(dependency: ArticleDependency) {
        super.init(dependency: dependency)
    }

    @available(iOS 13.0, *)
    func build(withListener listener: ArticleListener) -> ArticleRouting {
        
//        let viewController = ArticleViewController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let articleViewcontroller =  storyboard.instantiateViewController(identifier: "HomeVC") as?  ArticleViewController else {fatalError("error")}
//
        let interactor = ArticleInteractor(presenter: articleViewcontroller)
                let component = ArticleComponent(dependency: dependency)
                interactor.listener = listener
        
        let searchBuilder = SearchBuilder(dependency: component)

        return ArticleRouter(interactor: interactor, viewController: articleViewcontroller, searchBuilder: searchBuilder)
        
        
    
    }
}

extension ArticleComponent:SearchDependency{
    var searchViewController: SearchViewControllable {
        return articleController
    }

}









