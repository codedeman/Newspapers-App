//
//  DatePickerInteractor.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift

protocol DatePickerRouting: ViewableRouting {
    func cleanupViews()
    func routerToArticle(date:String)
   
}

protocol DatePickerPresentable: Presentable {
    var listener: DatePickerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DatePickerListener: class {
    
    func didSelectDate(date: String)

}

final class DatePickerInteractor: PresentableInteractor<DatePickerPresentable>, DatePickerInteractable, DatePickerPresentableListener {
    

    weak var router: DatePickerRouting?
    weak var listener: DatePickerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: DatePickerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    func didTapView() {
        router?.cleanupViews()
    }
    
    
     func didSelectDate(date: String) {
        listener?.didSelectDate(date: date)
//         router?.routerToArticle(date: date)
     }
     
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
