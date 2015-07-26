//
//  MemeMeTextfield.swift
//  MemeMe3
//
//  Created by jason on 05/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit
class MemeMeTextFieldDelegate : NSObject, UITextFieldDelegate {

    var topTextField    : UITextField!  = nil
    var bottomTextField : UITextField!  = nil
    var activeTextField : UITextField?  = nil

    init(topTextField : UITextField, andBottomTextField bottomTextField: UITextField) {
        super.init()
        self.topTextField           = topTextField
        self.bottomTextField        = bottomTextField
        topTextField.delegate       = self
        bottomTextField.delegate    = self
    }


    /*This callback method empties the top and bottom textfield when
    a user start to edit the textfield and the include their default strings.*/
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        if textField.text == "TOP" && textField === self.topTextField {
            textField.text = ""
        }
        else if textField.text == "BOTTOM" && textField === self.bottomTextField {
            textField.text = ""
        }

        self.activeTextField = textField

        return true
    }

    /*Callback method that is used for capitalizing all text inputs.
    Setting the attribute/property on the textfield doesn't
    work, therefore this callback has been implemented to do
    the job.*/
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if string.capitalizedString != string {
            textField.text = textField.text + string.capitalizedString
            return false
        } else {
            return true
        }
    }

    //Callback method that allows edition the textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}