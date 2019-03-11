//
//  TableViewController.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let item1 = TaskModel()
        item1.text = "Uncheck"
        uncheckedGroup.append(item1)
        uncheckedGroup.append(item1)
        uncheckedGroup.append(item1)
        let item = TaskModel()
        item.text = "Check"
        checkedGroup.append(item)
        checkedGroup.append(item)
        
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = uncheckedGroup[indexPath.row]
            item.Check()
        } else {
            let item = checkedGroup[indexPath.row]
            item.Check()
        }
    }
    
    override func tableView( _ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            uncheckedGroup.remove(at: indexPath.row)
        } else {
            checkedGroup.remove(at: indexPath.row)
        }
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

}
