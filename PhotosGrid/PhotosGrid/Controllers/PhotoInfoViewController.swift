//
//  PhotoInfoViewController.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-10.
//  Copyright © 2018 nil. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var creatorLabel: RoundedLabel!
    @IBOutlet var dateCreatedLabel: RoundedLabel!
    
    var photo: Photo!
    var photoIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLabels()
        self.setupImageView()
    }
    
    private func setupLabels() {
        creatorLabel.text = "Created by: " + photo.creator
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy' at 'h:mm a"
        dateCreatedLabel.text = formatter.string(from: photo.dateCreated)
    }
    
    private func setupImageView() {
        UnsplashAPIClient().fetchImage(for: photo) { (imageResult) -> Void in
            switch imageResult {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
