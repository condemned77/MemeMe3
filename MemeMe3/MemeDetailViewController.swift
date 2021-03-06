//
//  MemeDetailViewController.swift
//  MemeMe3
//
//  Created by Michael on 25/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit

//ViewController for displaying a created Meme in a larger version.
class MemeDetailViewController : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var memeImage : UIImage? = nil

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        print("viewDidLoad: imageView is \(self.imageView)")
        self.imageView.image =  memeImage
    }
}