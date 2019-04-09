//
//  MaterialTextButton.swift
//  ToDoList
//
//  Created by Trainee on 4/9/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import MaterialComponents



class MaterialTextButton: MDCButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        MDCTextButtonThemer.applyScheme(MDCButtonScheme(), to: self)
        self.setBackgroundColor(UIColor(red: 3/255, green: 218/255, blue: 192/255, alpha: 1))
    }
 

}
