//
//  NewsInteractor.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift


protocol NewsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol NewsPresentable: Presentable {
    var listener: NewsPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol NewsListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class NewsInteractor: PresentableInteractor<NewsPresentable>, NewsInteractable, NewsPresentableListener {

    weak var router: NewsRouting?
    weak var listener: NewsListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: NewsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
