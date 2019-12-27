//
//  RootViewController.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {
    func push(viecontroller: ViewControllable) {
        navigationController?.pushViewController(viecontroller.uiviewController, animated: false)
    }
    
    func present(viewController: ViewControllable) {
            pushViewController(viewController.uiviewController, animated: false)
    }
    
    func dismiss(viewController: ViewControllable) {
        
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
       

    }
    
    
    
    
    private var targetViewController: ViewControllable?
    private var animationInProgress = false

    weak var listener: RootPresentableListener?

    func replaceModal(viewController: ViewControllable?) {
        targetViewController = viewController
        
        guard !animationInProgress else {
            return
        }
        
        if presentedViewController != nil {
            animationInProgress = true
            dismiss(animated: true) { [weak self] in
                if self?.targetViewController != nil {
                    self?.presentTargetViewController()
                } else {
                    self?.animationInProgress = false
                }
            }
        } else {
            presentTargetViewController()
        }
        
        
    }
    
    private func presentTargetViewController() {
    
        if let targetViewController = targetViewController {
            animationInProgress = true
            present(targetViewController.uiviewController, animated: true) { [weak self] in
                self?.animationInProgress = false
            }
        }
    
    }

}
