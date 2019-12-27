//
//  DatePickerViewController.swift
//  VinidNews
//
//  Created by KIENPT6 on 12/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa
import SnapKit

protocol DatePickerPresentableListener: class {
    
    func didTapView()
    
    func didSelectDate(date:String)
    
}

final class DatePickerViewController: UIViewController, DatePickerPresentable, DatePickerViewControllable {
    
    func dismiss(viewController: ViewControllable) {
        
        dismiss(animated: false, completion: nil)
    }
    

    weak var listener: DatePickerPresentableListener?
    
    @IBOutlet weak var dateContentView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        blindingDoneButton()
        doneButton.isHidden = true
        setupToHideScreen()
        datePickerView.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        blindingDoneButton()
    }
    
    
    func setupToHideScreen()
       {
           let tap: UITapGestureRecognizer = UITapGestureRecognizer(
               target: self,
               action: #selector(dismissKeyboard))

           tap.cancelsTouchesInView = false
           view.addGestureRecognizer(tap)
       }
       
    
    @objc func dismissKeyboard()
       {
            listener?.didTapView()
       }
    
    
    @objc func dateChanged(_ sender:UIDatePicker){
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let _ = components.month, let _ = components.year {
            print(day)
            doneButton.isHidden = false
        }
        
    }
    
    
    func blindingDoneButton()  {
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            
            let date = self!.datePickerView.date
            let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let dateString = "\(components.year!)/" + "\(components.month!)"
            self?.listener?.didSelectDate(date: dateString)
            self!.dismiss(animated: false, completion: nil)
            
            }, onError: nil, onCompleted: nil).disposed(by: disposeBag)
    }


}
