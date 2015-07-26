//
//  MemeCollectionViewController.swift
//  MemeMe3
//
//  Created by Michael on 21/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var memes : [Meme]  {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appdelegate.memes
    }


    required init(coder aDecoder:  NSCoder) {
        super.init(coder: aDecoder)
    }


    @IBAction func addButtonPressed(sender:UIBarButtonItem){
        self.presentCreateMemeViewController()
    }


    func presentCreateMemeViewController() {
        let createMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("createMeme") as! CreateMemeViewController

        self.presentViewController(createMemeVC, animated: true, completion: nil)
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }


    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.imageView.image = self.memes[indexPath.row].memedImage
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let meme = self.memes[indexPath.row]

        var memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! MemeDetailViewController
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
        memeDetailVC.memeImage = meme.memedImage
    }
}