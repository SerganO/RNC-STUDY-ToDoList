//
//  TableViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import Firebase


class TableViewController: UITableViewController, AddViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    let ref = Database.database().reference(withPath:"task")
    
    func addItemViewController(_ controller: AddViewController, didFinishAdding task: TaskModel) {
        let text = task.text
        let taskRef = self.ref.child(text.lowercased())
        
        
        //taskRef.setValue(task.toAnyObject())
        taskRef.setValue(task.toDic())
        
        
//        let newRowIndex = uncheckedGroup.count
//        uncheckedGroup.append(task)
//        let indexPath = IndexPath(row: newRowIndex, section: 0)
//        let indexPaths = [indexPath]
//        tableView.insertRows(at: indexPaths, with: .automatic)
       
        navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?) {

        if segue.identifier == "AddTask" {
            let controller = segue.destination as! AddViewController
            controller.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
      
        ref.observe(.value, with : {
            snapshot in
            
            var tmpUncheck: [TaskModel] = []
            var tmpCheck: [TaskModel] = []
            
            for child in snapshot.children {
                
                if let snapshot = child as? DataSnapshot,
                    let task = TaskModel(snapshot: snapshot) {
                    if task.checked == false {
                        tmpUncheck.append(task)
                    } else {
                        tmpCheck.append(task)
                    }
                }
                
            }
            self.uncheckedGroup = tmpUncheck
            self.checkedGroup = tmpCheck
            self.tableView.reloadData()
        })
    }
    
    var checkedGroup = [TaskModel]();
    var uncheckedGroup = [TaskModel]();
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return uncheckedGroup.count
        } else if section == 1 {
            return checkedGroup.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item",for: indexPath)
        
        if indexPath.section == 0 {
            let item = uncheckedGroup[indexPath.row]
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = item.text
        } else {
            let item = checkedGroup[indexPath.row]
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = item.text
        }
        
        
        return cell
    }
    
    /*
     if indexPath.section == 0 {
     
     } else {
     
     }
     */
    
    @IBAction func Add()
    {
        let newRowIndex = uncheckedGroup.count
        
        let item = TaskModel()
        item.text = "I am a new row"
        uncheckedGroup.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func AddTaskToCheck(_ task: TaskModel)
    {
        let newRowIndex = checkedGroup.count
        checkedGroup.append(task)
        let indexPath = IndexPath(row: newRowIndex, section: 1)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    func AddTaskToUncheck(_ task: TaskModel)
    {
        let newRowIndex = uncheckedGroup.count
        uncheckedGroup.append(task)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            task.Check()
            AddTaskToCheck(task)
            let que = DispatchQueue.global()
            que.async {
                task.ref?.updateChildValues(["checked":true])
            }
            
            uncheckedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        } else {
            let task = checkedGroup[indexPath.row]
            task.Check()
            AddTaskToUncheck(task)
            let que = DispatchQueue.global()
            que.async {
            task.ref?.updateChildValues(["checked":false])
            }
            checkedGroup.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    override func tableView( _ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let task = uncheckedGroup[indexPath.row]
            let que = DispatchQueue.global()
            que.async {
            task.ref?.removeValue()
            }
            uncheckedGroup.remove(at: indexPath.row)
        } else {
            let task = checkedGroup[indexPath.row]
            let que = DispatchQueue.global()
            que.async {
            task.ref?.removeValue()
            }
            checkedGroup.remove(at: indexPath.row)
        }
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

}
