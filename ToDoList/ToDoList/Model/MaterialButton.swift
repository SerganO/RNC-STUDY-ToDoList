//
//  MaterialButton.swift
//  ToDoList
//
//  Created by Trainee on 4/16/19.
//  Copyright © 2019 Trainee. All rights reserved.
//

import UIKit
import MaterialComponents

class MaterialButton: MDCButton {
    
    let buttonSheme = MDCButtonScheme()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.lightGray.cgColor
        MDCButtonColorThemer.applySemanticColorScheme(buttonSheme.colorScheme, to: self)
        self.backgroundColor = UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = UIColor.lightGray.cgColor
        MDCButtonColorThemer.applySemanticColorScheme(buttonSheme.colorScheme, to: self)
        
        self.backgroundColor = UIColor(red: 0x26/255, green: 0xA6/255, blue: 0x9A, alpha: 1)
    }
    
}
