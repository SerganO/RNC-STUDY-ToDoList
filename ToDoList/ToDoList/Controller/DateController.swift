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

    
    let schema = MDCBasicColorScheme.init(primaryColor: UIColor.white, secondaryColor: UIColor.white)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let materialNavigation = navigationController as? CustomMaterialNavigation,
            let appBarVC = materialNavigation.appBarViewController(for: self) {
            MDCFlexibleHeaderColorThemer.apply(schema, to: appBarVC.headerView)
            MDCNavigationBarColorThemer.apply(schema, to: appBarVC.navigationBar)
        }
    }
    
    
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
        datePickerView.layer.cornerRadius = 10
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.backgroundColor = UIColor(red: 0xE0/255, green: 0xF2/255, blue: 0xF1/255, alpha: 1)
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        //blurEffectView.frame = datePickerView.frame
        self.view.insertSubview(blurEffectView, at: 0)
    }
    weak var delegate: DateControllerDelegate?
    
    

}


extension DateController:
UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return TransparentPresentationController(presentedViewController: presented,presenting: presenting)
    }
}
