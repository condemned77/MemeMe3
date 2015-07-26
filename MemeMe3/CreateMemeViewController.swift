//
//  ViewController.swift
//  MemeMe3
//
//  Created by jason on 27/06/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var memedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    var textFieldDelegate : MemeMeTextFieldDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.applyTextFieldAttributes(self.topTextField)
        self.applyTextFieldAttributes(self.bottomTextField)
        self.textFieldDelegate = MemeMeTextFieldDelegate(topTextField: self.topTextField, andBottomTextField: self.bottomTextField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }


    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func shareButtonPressed() {
        if self.imageView.image != nil {

            self.memedImage = self.generateMemedImage()
            let activityVC = UIActivityViewController(activityItems: [self.memedImage as! AnyObject], applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: {self.save()})
        } else {
            self.showAlertView("No Meme created, please add a photo from your album or take a photo.")
        }
    }

    /*convenience method for showing a simple alert with a
    message (passed as parameter)*/
    func showAlertView(message: String) {
        var alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func save() {
        //Create the meme
        var meme = Meme(topText: self.topTextField.text!,
                     bottomText: self.bottomTextField.text!,
                          image: self.imageView.image!,
                     memedImage: self.memedImage!)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        return memedImage
    }

    //callback method for the cancel button
    @IBAction func cancelButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    func showTabbar() {
        let tabbarcon = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarcon") as! UITabBarController
        self.showViewController(tabbarcon, sender: self)
    }


    //callback method for the camera button
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        self.pickAnImageFromCamera()
    }


    func pickAnImageFromCamera() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }


    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        println("picking finished")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.imageView.contentMode  = UIViewContentMode.ScaleAspectFit
            self.imageView.image        = image
        }
        self.memedImage = self.generateMemedImage()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }


    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        println("user canceled selection")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func albumButtonPressed(sender: AnyObject) {
        self.pickAnImageFromAlbum()
    }


    func pickAnImageFromAlbum() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }

    /*this method applies the desired textfield attributes to a provided text field instance.
    The font shall be as close as possible to the impact font.*/
    func applyTextFieldAttributes(textField: UITextField){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName :  UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -7.0
        ]
        textField.defaultTextAttributes     = memeTextAttributes
        textField.textAlignment             = NSTextAlignment.Center
        textField.autocapitalizationType    = UITextAutocapitalizationType.AllCharacters
    }


    /*Instances of this view controller class will subscribe to the following notification by
    the NSNotificationCenter:
    keyboardWillShow - when the user keyboard slides up.
    keyboardWillHide - when the user keyboard is going to slide down.*/
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }


    /*Unsubscribing from NSNotification callbacks regarding the 
    keyboard.*/
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }


    // called by the NSNotificationcenter when the keyboard is going to be displayed.
    func keyboardWillShow(notification: NSNotification) {
        if self.textFieldDelegate!.activeTextField === self.bottomTextField {
            self.view.frame.origin.y -= self.getKeyboardHeight(notification)
        }
    }


    // called by the NSNotificationcenter when the keyboard is going to be hidden.
    func keyboardWillHide(notification: NSNotification) {
        if self.textFieldDelegate!.activeTextField === self.bottomTextField{
            self.view.frame.origin.y += self.getKeyboardHeight(notification)
            self.textFieldDelegate!.activeTextField = nil
        }
    }


    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}