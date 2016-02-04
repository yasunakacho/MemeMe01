//
//  MemeTableViewController.swift
//  MemeMe01
//
//  Created by Yasunaka Cho on 2/2/16.
//  Copyright © 2016 Yasunaka Cho. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let step 5.8?/
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeCell")!
        let meme = memes[indexPath.row]
        cell.textLabel!.text = meme.topText
        cell.textLabel!.text = meme.bottomText
        cell.imageView!.image = meme.memedImage
        
        return cell
        }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("SentMemeDetailViewController") as! SentMemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }



}