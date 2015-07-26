//
//  MemeDetailViewController.swift
//  MemeMe3
//
//  Created by Michael on 25/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit


class MemeDetailViewController : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var memeImage : UIImage? = nil

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        println("viewDidLoad: imageView is \(self.imageView)")
        self.imageView.image =  memeImage
    }
}