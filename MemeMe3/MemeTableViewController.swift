//
//  MemeTableViewController.swift
//  MemeMe3
//
//  Created by Michael on 18/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    var memes : [Meme]!

    required init!(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder)
    }


    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memes = appDelegate.memes
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count;
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = self.memes[indexPath.row]

        var memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! MemeDetailViewController
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
        memeDetailVC.memeImage = meme.memedImage
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
        cell.imageView?.image = self.memes[indexPath.row].memedImage
        cell.textLabel?.text = self.memes[indexPath.row].description()
        return cell
    }
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {

        let createMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("createMeme") as! CreateMemeViewController

        self.presentViewController(createMemeVC, animated: true, completion: nil)
    }
}