//
//  MemeMeTextfield.swift
//  MemeMe3
//
//  Created by jason on 05/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit
class MemeMeTextField : UITextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.applyTextFieldAttributes()
    }
    
    /*this method applies the desired textfield attributes to a provided text field instance.
    The font shall be as close as possible to the impact font.*/
    func applyTextFieldAttributes(){
//        self.textAlignment = NSTextAlignment.Center
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName :  UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -7.0
        ]
        self.defaultTextAttributes = memeTextAttributes
    }
}
