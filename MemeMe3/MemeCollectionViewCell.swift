//
//  MemeCollectionViewCell.swift
//  MemeMe3
//
//  Created by Michael on 22/07/15.
//  Copyright (c) 2015 jason. All rights reserved.
//

import Foundation
import UIKit

/*Class for a custom cell of the CollectionViewController. Only holds a imageView instance
  for displaying the Meme itself within the cell.
*/
class MemeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
}