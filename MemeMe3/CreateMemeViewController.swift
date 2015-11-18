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
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toobar: UIToolbar!
    
    var textFieldDelegate : MemeMeTextFieldDelegate? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.applyTextFieldAttributes(self.topTextField)
        self.applyTextFieldAttributes(self.bottomTextField)
        self.textFieldDelegate = MemeMeTextFieldDelegate(topTextField: self.topTextField, andBottomTextField: self.bottomTextField)
    }

    /*Callback method when the will appear.
    Here the keyboard notification subscripting will be established,
    and the camera button we be disabled if a camera isn't avilable, e.g.
    when the application is run on a simulator.*/
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }


    //unsubscribe when the ViewVontroller will be dismissed.
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }


    /*callback method for the share button. This method presents the UIActivityView for sharing
    the created Meme. It's only possible to share the Meme if a Meme has been created.*/
    @IBAction func shareButtonPressed() {
        if self.imageView.image != nil {

            self.memedImage = self.generateMemedImage()
            let activityVC = UIActivityViewController(activityItems: [self.memedImage as! AnyObject], applicationActivities: nil)
            activityVC.completionWithItemsHandler = {activityTpe, completed, returnedItems, error in
                
                if completed {
                    print("activity vc completed", terminator: "");
                    self.saveMeme()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print("Not completed")
                }
            
            }
            //activityVC.completionWithItemsHandler = self.activityViewControllerCompleted
            self.presentViewController(activityVC, animated: true, completion: nil)
        } else {
            self.showAlertView("No Meme created, please add a photo from your album or take a photo.")
        }
    }


    /*callback method for when the ActivityView is dismissed. This method has to conform to
    the declaration of completionWithItemsHandler of the class UIActivityViewController.*/
    func activityViewControllerCompleted(activityTpe : String?, completed : Bool, returnedItems: [AnyObject]!, error : NSError!) -> Void{

        if completed {
            print("activity vc completed", terminator: "");
            self.saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("Not completed")
        }
    }

    /*convenience method for showing a simple alert with a
    message (passed as parameter)*/
    func showAlertView(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


    //This method stores the Meme within the global (shared) data container.
    func saveMeme() {
        //Create the meme
        let meme = Meme(topText: self.topTextField.text!,
                     bottomText: self.bottomTextField.text!,
                          image: self.imageView.image!,
                     memedImage: self.memedImage!)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        print("Meme: \(meme) saved. Meme count: \(appDelegate.memes.count)")
    }


    //this method create the Memed imaged and returns the newly created UIImage instance.
    func generateMemedImage() -> UIImage {
        
        self.toggleViewBarsVisibility()

        // Render view to an image
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        self.view.drawViewHierarchyInRect(self.imageView.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.toggleViewBarsVisibility()
        return memedImage
    }

    //allows to toggle between showing the navigation and tool bar and hiding them.
    func toggleViewBarsVisibility() {
        self.navigationBar.hidden   = !self.navigationBar.hidden
        self.toobar.hidden          = !self.toobar.hidden
    }

    //callback method for the cancel button
    @IBAction func cancelButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }


    //callback method for the camera button
    @IBAction func cameraButtonPressed(sender: UIBarButtonItem) {
        self.pickAnImageFromCamera()
    }


    /*This method creates an UIImagePickerController instance and configures it in such a way
    that it accesses the device camera.*/
    func pickAnImageFromCamera() {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerVC, animated: true, completion: nil)
    }


    /*delegate method that is called when the user has choosen an image from the UIImagePickerController.
    When an image has been choosen from the image picker, or an image has been taken using 
    the camera, the image is stored in the imageView of this ViewController.
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("picking finished")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            self.imageView.contentMode  = UIViewContentMode.ScaleAspectFit
            self.imageView.image        = image
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    //callback method for when the album button is pressed.
    @IBAction func albumButtonPressed(sender: AnyObject) {
        self.pickAnImageFromAlbum()
    }


    /*This method create a UIImagePickerController which accesses the user's
    photos.*/
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


    //This method calculates and returns the keyboard height.
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}