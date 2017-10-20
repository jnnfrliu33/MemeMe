//
//  MemeCollectionViewController.swift
//  MemeMeV2
//
//  Created by Jennifer Liu on 07/10/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit

// MARK: - MemeCollectionViewController: UICollectionViewController

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // MARK: Properties
    
    // To access the array of memes stored in Application Delegate
    var memes: [Meme] { return (UIApplication.shared.delegate as! AppDelegate).memes }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Flow Layout
        let space: CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
        
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue a reusable cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        // Access saved meme for a given row
        let meme: Meme = memes[(indexPath as NSIndexPath).row]
        
        // Set the label and image
        cell.memeImageView.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
