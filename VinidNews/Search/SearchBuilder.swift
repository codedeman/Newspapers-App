//
//  SearchBuilder.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol SearchDependency: Dependency {
    
    var searchViewController: SearchViewControllable { get }
}

final class SearchComponent: Component<SearchDependency> {
    let searchView = SearchViewController()
    fileprivate var loggedInViewController: SearchViewControllable {
        return dependency.searchViewController
    }

}

// MARK: - Builder

protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

@available(iOS 13.0, *)
final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }
    

    @available(iOS 13.0, *)
    func build(withListener listener: SearchListener) -> SearchRouting {
        let component = SearchComponent(dependency: dependency)
        guard  let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchView") as? SearchViewController else {fatalError("error")}
        searchViewController.modalPresentationStyle = .fullScreen
        
        let interactor = SearchInteractor(presenter: searchViewController)
        interactor.listener = listener
        let articleBuilder = ArticleBuilder(dependency: component)
        
        let searchBuilder = SearchBuilder(dependency: component)

        return SearchRouter(interactor: interactor, viewController: searchViewController, articleBuilder: articleBuilder, searchBuilder: searchBuilder)
    }
}

extension SearchComponent:ArticleDependency{
    var searchViewController: SearchViewControllable {
        return searchView
    }
    
    
    


}

extension SearchComponent:SearchDependency{
//    var searchViewController: SearchViewControllable {
//        return searchViewController
//    }

}


