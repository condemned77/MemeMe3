//
//  ViewController.swift
//  MemeMe3
//
//  Created by jason on 27/06/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var memedImage: UIImage?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: MemeMeTextField!
    @IBOutlet weak var topTextField: MemeMeTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = self.createShareButton()
        self.navigationItem.rightBarButtonItem = self.createCancelButton()

    }

    func shareButtonPressed() {
        self.memedImage = self.generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [self.memedImage as! AnyObject], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: {self.save()})
    }
    
    func save() {
        //Create the meme
        
        var meme = Meme(topText: self.topTextField.text!,
            bottomText: self.bottomTextField.text!,
            image: self.imageView.image!,
            memedImage: self.memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        return memedImage
    }
    
   

    func createCancelButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "shareAction")
    }
    
    func createShareButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareButtonPressed")
    }

    func shareAction() {
        let tabbarcon = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarcon") as! UITabBarController

        self.showViewController(tabbarcon, sender: self)
    }

}

