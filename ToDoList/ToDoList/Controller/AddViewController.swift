//
//  AddViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: class {
    func addViewControllerDidCancel(
        _ controller: AddViewController)
    func addViewController(
        _ controller: AddViewController,
        didFinishAdding task: TaskModel)
    func addViewController(
        _ controller: AddViewController,
        didFinishEditing task: TaskModel)
}

class AddViewController: UIViewController, UITextViewDelegate, DateControllerDelegate {
    func dateControllerDidCancel(_ controller: DateController) {
        dismiss(animated: true, completion: nil)

    }
    
    func dateController(_ controller: DateController, dateSeting date: Date) {
        dueDate = date
        updateDueDateLabel()
        dismiss(animated: true, completion: nil)
    }
    

    weak var delegate: AddViewControllerDelegate?
    
    @IBOutlet weak var setDateButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var DateViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    var datePickerVisible = false
    
    var dueDate = Date()
    
    var taskToEdit: TaskModel?
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textView: UITextView!
    
    var textViewFrame: CGRect?
    var keyboardHeight: CGFloat = 0.0
    var DateHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dueDateLabel.isHidden = true
        let bar = UIToolbar()
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let hide = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(hideTapped))
        bar.items = [flexsibleSpace,hide]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        textViewFrame = self.view.frame
        if let task = taskToEdit {
            title = "Edit"
            textView.text = task.text
            doneBarButton.isEnabled = true
            if let nd = task.notificationDate {
                shouldRemindSwitch.isOn = true
                dueDate = nd
            } else {
                dueDate = Date()
            }
        }
        if shouldRemindSwitch.isOn {
            print("On")
            DateViewHeight.constant = 30
            dueDateLabel.isHidden = false
            dateLabel.isHidden = false
            setDateButton.isHidden = false
        } else {
            print("Of")
            DateViewHeight.constant = 0
            dueDateLabel.isHidden = true
            dateLabel.isHidden = true
            setDateButton.isHidden = true
        }
        self.view.layoutIfNeeded()
        updateDueDateLabel()
    }
    
    @objc func hideTapped()
    {
        textView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            viewHeight.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
            viewHeight.constant = 0
            self.view.layoutIfNeeded()
    }
    
    @IBAction func cancel() {
        delegate?.addViewControllerDidCancel(self)
    }
    
    @IBAction func onOf() {
        if shouldRemindSwitch.isOn {
            print("On")
            DateViewHeight.constant = 30
            dueDateLabel.isHidden = false
            dateLabel.isHidden = false
            setDateButton.isHidden = false
        } else {
            print("Of")
            DateViewHeight.constant = 0
            dueDateLabel.isHidden = true
            dateLabel.isHidden = true
            setDateButton.isHidden = true
        }
         self.view.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {
        
        if segue.identifier == "SetDate" {
            let controller = segue.destination as! DateController
            controller.delegate = self
        }
    }
    
    @IBAction func done() {
        if(textView.text == "") {
            let alert = UIAlertController(title: "Empty Task", message: "Please write anothing", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            if let task = taskToEdit {
                task.text = textView.text
                if shouldRemindSwitch.isOn {
                    task.notificationDate = dueDate
                } else {
                    task.notificationDate = nil
                }
                
                
                delegate?.addViewController(self, didFinishEditing: task)
            } else {
                let task = TaskModel()
                task.text = textView.text
                task.date = Date()
                task.checked = false
                if shouldRemindSwitch.isOn {
                    task.notificationDate = dueDate
                } else {
                    task.notificationDate = nil
                }
                delegate?.addViewController(self, didFinishAdding: task)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .long
        formatter.dateFormat = "EEEEEEEE"
        let c = formatter.string(from: dueDate).capitalized
        formatter.dateFormat = "MMM d hh:mm"
        dueDateLabel.text =  c + " " + formatter.string(from: dueDate)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
