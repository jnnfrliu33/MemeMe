//
//  MemeDetailViewController.swift
//  MemeMeV2
//
//  Created by Jennifer Liu on 06/10/2017.
//  Copyright © 2017 Jennifer Liu. All rights reserved.
//

import UIKit

// MARK: - MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make sure image is set
        guard self.imageView.image != nil else {
            print ("Image not found")
            return
        }
    }
}
