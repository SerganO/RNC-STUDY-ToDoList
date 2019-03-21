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

class AddViewController: UIViewController, UITextViewDelegate {

    weak var delegate: AddViewControllerDelegate?
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    
    var taskToEdit: TaskModel?
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var textView: UITextView!
    
    var textViewFrame: CGRect?
    var keyboardHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        super.viewDidLoad()
        textViewFrame = self.view.frame
        if let task = taskToEdit {
            title = "Edit"
            textView.text = task.text
            doneBarButton.isEnabled = true
        }
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            //textView.contentSize.height += keyboardHeight
            viewHeight.constant = keyboardHeight
            self.view.layoutIfNeeded()
            /*var frame = textViewFrame!
            frame.size.height = frame.size.height - keyboardHeight - 5
            self.textView.frame = frame*/
        }
    }
    
    @IBAction func cancel() {
        delegate?.addViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let task = taskToEdit {
            task.text = textView.text
            
            delegate?.addViewController(self, didFinishEditing: task)
        } else {
            let task = TaskModel()
            task.text = textView.text
            task.date = Date()
            task.checked = false
            delegate?.addViewController(self, didFinishAdding: task)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        textView.becomeFirstResponder()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

   /*func textView(_ textView: UITextView,
                      shouldChangeCharactersIn range: NSRange,
                      replacementString string: String) -> Bool {
        
        let oldText = textView.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }*/
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
