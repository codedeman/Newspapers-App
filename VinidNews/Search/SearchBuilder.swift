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
    
    fileprivate var loggedInViewController: SearchViewControllable {
        return dependency.searchViewController
    }

}

// MARK: - Builder

protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }
    

    func build(withListener listener: SearchListener) -> SearchRouting {
        _ = SearchComponent(dependency: dependency)
        guard  let searchViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "searchView") as? SearchViewController else {fatalError("error")}
        
        searchViewController.modalPresentationStyle = .fullScreen
        
        let interactor = SearchInteractor(presenter: searchViewController)
        interactor.listener = listener
        return SearchRouter(interactor: interactor, viewController: searchViewController)
    }
}
