//
//  MemeTableViewController.swift
//  MemeMeV2
//
//  Created by Jennifer Liu on 06/10/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit

// MARK: - MemeTableViewController: UITableViewController

class MemeTableViewController: UITableViewController {
    
    // MARK: Properties
    
    // To access the array of memes stored in Application Delegate
    var memes: [Meme] { return (UIApplication.shared.delegate as! AppDelegate).memes }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!

        // Access saved meme for a given row
        let meme: Meme = memes[(indexPath as NSIndexPath).row]

        // Set the label and image
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        cell.imageView?.image = meme.memedImage

        print(meme.topText)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Retrieve the meme to be displayed in the Meme Detail View Controller
        let meme: Meme = memes[(indexPath as NSIndexPath).row]
        
        // Instantiate Meme Detail View Controller to load its view and connect its outlets
        _ = detailController.view
        
        // Set the meme image that will be displayed in the Meme Detail View Controller
        detailController.imageView.image = meme.memedImage
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
