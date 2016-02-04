//
//  SentMemeDetailViewController.swift
//  MemeMe01
//
//  Created by Yasunaka Cho on 2/4/16.
//  Copyright © 2016 Yasunaka Cho. All rights reserved.
//

import Foundation
import UIKit

class SentMemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView!.image = UIImage(named: meme.topText!)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

}
