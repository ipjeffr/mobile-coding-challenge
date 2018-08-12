//
//  PhotosViewController.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-07.
//  Copyright © 2018 nil. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    private var viewModel: PhotosViewModel!
    private let cellIdentifier = "PhotoCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        viewModel = PhotosViewModel(delegate: self)
        viewModel.fetchPhotos()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto"?:
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = viewModel.photo(at: selectedIndexPath.item)
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.viewModel = viewModel
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            let photo = viewModel.photo(at: indexPath.item)
            viewModel.fetchImage(for: photo)
        }
    }
}

extension PhotosViewController: PhotosViewModelDelegate {
    
    func photosFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {

        guard let newIndexPathsToReload = newIndexPathsToReload else {
            collectionView.reloadData()
            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        collectionView.reloadItems(at: indexPathsToReload)
    }
    
    func imageFetchCompleted(at photoIndex: Int, for image: UIImage) {
        let photoIndexPath = IndexPath(item: photoIndex, section: 0)
        
        // When the request finishes, only update the cell if it's still visible
        if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
            if self.isLoadingCell(for: photoIndexPath) {
                cell.update(with: nil)
            } else {
                cell.update(with: image)
            }
        }
    }
    
    func fetchFailed(with reason: String) {
        debugPrint(reason)
    }
}

extension PhotosViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPhotos()
        }
    }
}

private extension PhotosViewController {
    //determines if indexPath requested is out of current range
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems 
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
