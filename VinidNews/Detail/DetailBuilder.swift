//
//  DetailBuilder.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/24/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol DetailDependency: Dependency {
   
}

final class DetailComponent: Component<DetailDependency> {

}

// MARK: - Builder

protocol DetailBuildable: Buildable {
    func build(item: URL) -> DetailRouting
}

@available(iOS 13.0, *)
final class DetailBuilder: Builder<DetailDependency>, DetailBuildable {
    
    override init(dependency: DetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(item: URL) -> DetailRouting {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   guard let viewcontroller =  storyboard.instantiateViewController(identifier: "NewsDetailVC") as?  DetailViewController else {fatalError("error")}
           viewcontroller.item = item
           let interactor = DetailInteractor(presenter: viewcontroller)
           
           return DetailRouter(interactor: interactor, viewController: viewcontroller)
           
       }


}
