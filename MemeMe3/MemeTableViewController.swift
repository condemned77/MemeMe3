//
//  MemeTableViewController.swift
//  MemeMe3
//
//  Created by Michael on 18/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {

    var memes : [Meme]  {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appdelegate.memes
    }

    required init!(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    //delegate method for returning the amount of cells in the table view.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count;
    }


    /*delegate method for reacting when the user clicked on a table view cell.
    In this case, the Meme being pressed is displayed in a bigger version in an own ViewController.
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let meme = self.memes[indexPath.row]

        let memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailVC") as! MemeDetailViewController
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
        memeDetailVC.memeImage = meme.memedImage
    }


        //delegate method for returning the amount of items in the collection view.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")
        cell!.imageView?.image = self.memes[indexPath.row].memedImage
        cell!.textLabel?.text = self.memes[indexPath.row].description()
        return cell!
    }

    //callback for adding the + button
    @IBAction func addButtonPressed(sender: UIBarButtonItem) {
        self.presentCreateMemeViewController()
    }

    //convenience method for presenting the CreateMemeViewController on top of the TableViewController
    func presentCreateMemeViewController() {
        let createMemeVC = self.storyboard?.instantiateViewControllerWithIdentifier("createMeme") as! CreateMemeViewController

        self.presentViewController(createMemeVC, animated: true, completion: nil)
    }
}