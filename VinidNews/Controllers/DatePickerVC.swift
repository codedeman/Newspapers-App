//
//  DatePickerVC.swift
//  VinidNews
//
//  Created by Apple on 11/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
protocol SendBackData {
    func sendDataToBack(value: String)
}

class DatePickerVC: UIViewController {
    

    var delegate: SendBackData?
    
    var newsViewModel = NewsViewModel()
    var disposeBag = DisposeBag()


    @IBOutlet weak var selectedButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var date:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        
        selectedButton.isHidden = true
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getCurrent()

    }
    
    
    @IBAction func selectedButonWasPressed(_ sender: Any) {
        
        let date = datePicker.date
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        let dateString = "\(components.year!)/" + "\(components.month!)"
              
        self.delegate?.sendDataToBack(value: dateString)
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
   
    
    @objc func dateChanged(_ sender:UIDatePicker){
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
                
        if let day = components.day, let _ = components.month, let _ = components.year {
                          selectedButton.isHidden = false
                    
                    print("day \(day)")
                          
        }
        

    }
    
 
    
    func setupToHideScreen()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()

          dateFormatter.dateStyle = DateFormatter.Style.short
          dateFormatter.timeStyle = DateFormatter.Style.short

        _ = dateFormatter.string(from: datePicker.date)
    }
    @objc func dismissKeyboard()
    {
        dismiss(animated: true, completion: nil)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
