//
//  ButtonWithBorder.swift
//  ToDoList
//
//  Created by Trainee on 4/4/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit

class ButtonWithBorder: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
