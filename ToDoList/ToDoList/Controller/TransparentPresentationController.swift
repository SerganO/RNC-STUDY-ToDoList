//
//  DimmingPresentationController.swift
//  ToDoList
//
//  Created by Trainee on 4/3/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class TransparentPresentationController: UIPresentationController {
    
    override var shouldRemovePresentersView: Bool {
        return false
    }
    
    
}

