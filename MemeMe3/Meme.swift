//
//  Meme.swift
//  MemeMe3
//
//  Created by jason on 04/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit
struct Meme {

    let topText         : String
    let bottomText      : String
    let image           : UIImage?
    let memedImage      : UIImage


    func description() -> String {
        return "\(self.topText) \(self.bottomText)"
    }
//    static let TopTextKey       = "TopTextKey"
//    static let BottomTextKey    = "BottomTextKey"

    // Generate a Meme from a three entry dictionary

//    init(texts: [String : String], image : UIImage?, memedImage : UIImage) {
//
//        self.topText        = texts[Meme.TopTextKey]!
//        self.bottomText     = texts[Meme.BottomTextKey]!
//        self.image          = image
//        self.memedImage     = memedImage
//    }
}


/**
* This extension adds a static variable defaultMeme. An array of predefined Meme objects
* which are easily instanciateable and accessible through the method defaultMemes().
*/

extension Meme {

    // Generate an array full of all of the villains in
    static var defaultMemes: [Meme] {

        var memesArray = [Meme]()

        memesArray.append(Meme(topText: "Love is in the air?", bottomText: "Wrong. Nitrogen, Oxygen, and Carbondyoxide are in the air!", image: nil, memedImage: UIImage(named: "Sheldon")!))

        memesArray.append(Meme(topText: "Pass?", bottomText: "Just get the rebound.", image: nil, memedImage: UIImage(named: "Kobe")!))

        memesArray.append(Meme(topText: "Real Life?", bottomText: "Never heard of that server", image: nil, memedImage: UIImage(named:"RealLife")!))

        return memesArray
    }
}