//
//  CellModel.swift
//  ToDoList
//
//  Created by Trainee on 3/11/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import Foundation

class TaskModel
{
    var text = ""
    var date = Date()
    var checked = false
    
    func Check(){
        checked = !checked
    }
}


