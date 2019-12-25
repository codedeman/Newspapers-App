//
//  DatePickerBuilder.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs

protocol DatePickerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DatePickerComponent: Component<DatePickerDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol DatePickerBuildable: Buildable {
    func build(withListener listener: DatePickerListener) -> DatePickerRouting
}

@available(iOS 13.0, *)
final class DatePickerBuilder: Builder<DatePickerDependency>, DatePickerBuildable {

    override init(dependency: DatePickerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DatePickerListener) -> DatePickerRouting {
        let component = DatePickerComponent(dependency: dependency)
        let viewController = DatePickerViewController()
        viewController.modalPresentationStyle = .overFullScreen
        let interactor = DatePickerInteractor(presenter: viewController)
        interactor.listener = listener
        let datePickerBuilder = DatePickerBuilder(dependency: component)
        let articleBuilder = ArticleBuilder(dependency: component)
        return DatePickerRouter(interactor: interactor, viewController: viewController, datePickerBuilder: datePickerBuilder, articleBuilder: articleBuilder)
    }
}

extension DatePickerComponent:DatePickerDependency{
    
    
    
}

extension DatePickerComponent:ArticleDependency{
    
    
}
