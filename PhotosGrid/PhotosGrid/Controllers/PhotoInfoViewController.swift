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
        self.setupSwipeDownToClose()
    }
    
    // MARK: - Setup
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
    
    // MARK: - Close Page
    private func setupSwipeDownToClose() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(gesture:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleSwipeGesture(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.down {
            self.actionClose()
        }
    }
    
    @IBAction func didTapCloseButton(_ sender: CloseButton) {
        self.actionClose()
    }
    
    private func actionClose() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
