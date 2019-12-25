//
//  RootBuilder.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {
   
}

final class RootComponent: Component<RootDependency> {

    let rootViewController:RootViewController
    
    init(dependency: RootDependency,rootViewController:RootViewController) {
        self.rootViewController = rootViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    
    func build() -> LaunchRouting
}

@available(iOS 13.0, *)
final class RootBuilder: Builder<RootDependency>, RootBuildable {
   
    

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
    
    @available(iOS 13.0, *)
    func build() -> LaunchRouting {
           
         let viewController = RootViewController()
        
                let component = RootComponent(dependency: dependency, rootViewController: viewController)
                let interactor = RootInteractor(presenter: viewController)
                let articleBuilder =  ArticleBuilder(dependency: component)
//                interactor.listener = listener
                let router = RootRouter(interactor: interactor, viewController: viewController, articleBuilder: articleBuilder)
                return  router
        
       }


}

