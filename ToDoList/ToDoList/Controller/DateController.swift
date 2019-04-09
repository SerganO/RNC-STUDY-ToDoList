//
//  DateController.swift
//  ToDoList
//
//  Created by Trainee on 4/2/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import MaterialComponents

protocol DateControllerDelegate: class {
    func dateControllerDidCancel(
        _ controller: DateController)
    func dateController(
        _ controller: DateController,
        dateSeting date: Date)
}

class DateController: UIViewController {
    let mainColor = UIColor(red: 3/255, green: 218/255, blue: 192/255, alpha: 1)
    let secondColor = UIColor(red: 1/255, green: 0x86/255, blue: 0x87/255, alpha: 1)
    let backgroundColor = UIColor(red: 0xE0/255, green: 0xF2/255, blue: 0xF1/255, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = self
    }
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func ok(_ sender: Any) {
        delegate?.dateController(self, dateSeting: datePicker.date)
    }
    @IBAction func Cancel(_ sender: Any) {
        delegate?.dateControllerDidCancel(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.backgroundColor = backgroundColor
        datePickerView.layer.cornerRadius = 10
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
    }
    weak var delegate: DateControllerDelegate?


}


extension DateController:
UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return TransparentPresentationController(presentedViewController: presented,presenting: presenting)
    }
}
