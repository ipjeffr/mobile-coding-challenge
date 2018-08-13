//
//  PhotosViewModel.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-11.
//  Copyright © 2018 nil. All rights reserved.
//

import UIKit

protocol PhotosViewModelDelegate: class {
    func photosFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func imageFetchCompleted(at photoIndex: Int, for image: UIImage)
    func fetchFailed(with reason: String)
}

final class PhotosViewModel {
    private weak var delegate: PhotosViewModelDelegate?
    private var photos = [Photo]()
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client = UnsplashAPIClient()
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return photos.count
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func index(of photo: Photo) -> Int? {
        return self.photos.index(of: photo)
    }
    
    func getPhotos() -> [Photo] {
        return photos
    }
    
    init(delegate: PhotosViewModelDelegate) {
        self.delegate = delegate
    }
    
    func fetchPhotos() {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        
        client.fetchPhotos(page: currentPage) { (result, totalPhotos) -> Void in
            switch result {
            case .success(let photos):
                self.isFetchInProgress = false
                
                self.total = totalPhotos
                self.photos.append(contentsOf: photos)

                if self.currentPage > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: photos)
                    self.delegate?.photosFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.photosFetchCompleted(with: .none)
                }
    
                self.currentPage += 1
                
            case .failure(let error):
                print("Error fetching photos: \(error)")
                self.isFetchInProgress = false
                self.delegate?.fetchFailed(with: error.localizedDescription)
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newPhotos: [Photo]) -> [IndexPath] {
        let startIndex = photos.count - newPhotos.count
        let endIndex = startIndex + newPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
        
    func fetchImage(for photo: Photo) {
        client.fetchImage(for: photo) { (imageResult) -> Void in
            switch imageResult {
            case .success(let image):
                if let photoIndex = self.index(of: photo) {
                    DispatchQueue.main.async {
                        self.delegate?.imageFetchCompleted(at: photoIndex, for: image)
                    }
                }
            case .failure(let error):
                self.delegate?.fetchFailed(with: error.localizedDescription)
            }
        }
    }
}
