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
    @IBOutlet weak var collectionView : UICollectionView!
    var memes : [Meme]  {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appdelegate.memes
    }

    override func viewWillAppear(animated: Bool) {
        self.collectionView.reloadData()
    }

    required init(coder aDecoder:  NSCoder) {
        super.init(coder: aDecoder)
    }

    //callback for adding the + button
    @IBAction func addButtonPressed(sender:UIBarButtonItem){
        self.presentCreateMemeViewController()
    }


    //convenience method for presenting the CreateMemeViewController on top of this ViewController
    func presentCreateMemeViewController() {
        let createMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("createMeme") as! CreateMemeViewController

        self.presentViewController(createMemeVC, animated: true, completion: nil)
    }


    //delegate method for returning the amount of items in the collection view.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    //delegate method for returning the collection view cell filled with a Meme image
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.imageView.image = self.memes[indexPath.row].memedImage
        return cell
    }

    /*delegate method for reacting when the user clicked on a collection view cell.
      In this case, the Meme being pressed is displayed in a bigger version in an own ViewController.
    */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let meme = self.memes[indexPath.row]

        var memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! MemeDetailViewController
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
        memeDetailVC.memeImage = meme.memedImage
    }
}