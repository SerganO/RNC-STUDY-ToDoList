//
//  DateController.swift
//  ToDoList
//
//  Created by Trainee on 4/2/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class DateController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func ok(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.locale = Locale(identifier: "en_GB")
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
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
