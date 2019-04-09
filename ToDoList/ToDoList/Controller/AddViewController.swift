//
//  AddViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import UserNotifications
import MaterialComponents

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
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var setDateButton: MDCButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var DateViewHeight: NSLayoutConstraint!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    //@IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    let mainColor = UIColor(red: 3/255, green: 218/255, blue: 192/255, alpha: 1)
    let secondColor = UIColor(red: 1/255, green: 0x86/255, blue: 0x87/255, alpha: 1)
    let backgroundColor = UIColor(red: 0xE0/255, green: 0xF2/255, blue: 0xF1/255, alpha: 1)
    let reminderColor = UIColor(red: 0xB2/255, green: 0xDF/255, blue: 0xDB/255, alpha: 1)
    
    var dueDate = Date()
    var taskToEdit: TaskModel?
    var textViewFrame: CGRect?
    var keyboardHeight: CGFloat = 0.0
    var DateHeight: CGFloat = 0.0
    let buttonScheme = MDCButtonScheme()
    var MBut = MDCFloatingButton()
    var MButN = MDCFloatingButton()
    let dColorSheme = MDCSemanticColorScheme(defaults: .material201804)
    let MNavigationBar = MDCNavigationBar()
    
    
    
    var appBarViewController = MDCAppBarViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        shouldRemindSwitch.tintColor = mainColor
        shouldRemindSwitch.onTintColor = mainColor
        
        
        setDateButton.setTitle("", for: .normal)
        setDateButton.setImage(UIImage(named: "Date"),for: .normal)
        appBarViewController.view.backgroundColor = secondColor
        self.addChild(self.appBarViewController)
        self.view.addSubview(self.appBarViewController.view)
        let backItemImage = UIImage(named: "Back")
        let templatedBackItemImage = backItemImage?.withRenderingMode(.alwaysTemplate)
        let backButton = MaterialButton()
        backButton.setImage(templatedBackItemImage, for: .normal)
        backButton.addTarget(self, action: #selector(BackPressed), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem
        
        let doneItemImage = UIImage(named: "Done")
        let templatedDoneItemImage = doneItemImage?.withRenderingMode(.alwaysTemplate)
        let doneButton = MaterialButton()
        doneButton.setImage(templatedDoneItemImage, for: .normal)
        doneButton.addTarget(self, action: #selector(DonePressed), for: .touchUpInside)
        let doneItem = UIBarButtonItem(customView: doneButton)
        self.navigationItem.rightBarButtonItem = doneItem
      
        
        let hideButton = MaterialButton()
        hideButton.setTitle("Hide", for: .normal)
        hideButton.addTarget(self, action: #selector(hideTapped), for: .touchUpInside)
        MDCTextButtonThemer.applyScheme(buttonScheme, to: hideButton)
        hideButton.setBackgroundColor(mainColor)
        hideButton.sizeToFit()
        
        dueDateLabel.isHidden = true
        let bar = UIToolbar()
        let flexsibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //let hide = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(hideTapped))
        let hide = UIBarButtonItem(customView: hideButton)
        bar.items = [flexsibleSpace,hide]
        bar.sizeToFit()
        textView.inputAccessoryView = bar
        bar.backgroundColor = secondColor
        
        
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
            MBut.isHidden = false
        } else {
            print("Of")
            DateViewHeight.constant = 0
            dueDateLabel.isHidden = true
            dateLabel.isHidden = true
            setDateButton.isHidden = true
            MBut.isHidden = true
        }
        self.view.layoutIfNeeded()
        updateDueDateLabel()
    }
    
    @objc func hideTapped()
    {
        textView.resignFirstResponder()
    }
    
    @objc func MDCBUTTON_TEST() {
        performSegue(withIdentifier: "SetDate", sender: self)
    }
    
    @objc func BackPressed() {
        cancel()
    }
    
    @objc func DonePressed() {
        done()
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
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in
                
            }
        }
        
        
        if shouldRemindSwitch.isOn {
            print("On")
            DateViewHeight.constant = 30
            dueDateLabel.isHidden = false
            dateLabel.isHidden = false
            setDateButton.isHidden = false
            
            MBut.isHidden = false
        } else {
            print("Of")
            DateViewHeight.constant = 0
            dueDateLabel.isHidden = true
            dateLabel.isHidden = true
            setDateButton.isHidden = true
            
            MBut.isHidden = true
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
        formatter.locale = Locale(identifier: "en_GB")
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
