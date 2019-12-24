//
//  OfflineViewController.swift
//  VinidNews
//
//  Created by Apple on 12/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupToHideScreen()

        // Do any additional setup after loading the view.
    }
    
    
    func setupToHideScreen()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(bacward))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func bacward(){
        
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
