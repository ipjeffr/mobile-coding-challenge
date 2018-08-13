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
    
    private let transition = TransitionAnimator()
    private var selectedCell: PhotoCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        viewModel = PhotosViewModel(delegate: self)
        viewModel.fetchPhotos()
        
        transition.dismissCompletion = {
            self.selectedCell?.imageView.isHidden = false
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
}

// MARK: - CollectionView Flow Layout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        let percentOfScreen: CGFloat = 0.2
        return CGSize(width: width * percentOfScreen,
                      height: height * percentOfScreen)
    }
}

// MARK: - CollectionView Data Source
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        return cell
    }
}

// MARK: - CollectionView Delegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            let photo = viewModel.photo(at: indexPath.item)
            viewModel.fetchImage(for: photo)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell
        let photosPageVC = storyboard!.instantiateViewController(withIdentifier: "PhotosPageViewController") as! PhotosPageViewController
        photosPageVC.photos = viewModel.getPhotos()
        photosPageVC.currentIndex = indexPath.item
        photosPageVC.visibleCellDelegate = self
        
        photosPageVC.transitioningDelegate = self
        present(photosPageVC, animated: true, completion: nil)
    }
}

// MARK: - CollectionView Prefetching
extension PhotosViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchPhotos()
        }
    }
}

// MARK: - ViewModel Delegate
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

// MARK: - CollectionView and ViewModel Helper Functions
private extension PhotosViewController {
    // Determines if indexPath requested is out of current range
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.item >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems 
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: - PhotosPageViewController Visible Cell Delegate
extension PhotosViewController: PhotosPageViewControllerDelegate {
    func updateSelectedCell(at index: Int) {
        let newSelectedIndexPath = IndexPath(item: index, section: 0)
        let visibleCellIndexPaths = collectionView.indexPathsForVisibleItems
        
        if visibleCellIndexPaths.contains(newSelectedIndexPath) == false {
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: newSelectedIndexPath, at: .centeredVertically, animated: false)
                self.view.layoutIfNeeded() // Forces the view to update its layout immediately.
                self.updateSelectedCell(at: index)
            }
        } else {
            self.selectedCell?.imageView.isHidden = false
            self.selectedCell = collectionView.cellForItem(at: newSelectedIndexPath) as? PhotoCollectionViewCell
            self.selectedCell?.imageView.isHidden = true
        }
    }
}

// MARK: - Custom Transition
extension PhotosViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        updateTransitionFrame()
        
        transition.presenting = true
        selectedCell!.imageView.isHidden = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        updateTransitionFrame()
        transition.presenting = false
        return transition
    }
    
    fileprivate func updateTransitionFrame() {
        guard let selectedCell = selectedCell,
            let indexPath = collectionView.indexPath(for: selectedCell),
            let attributes = collectionView.layoutAttributesForItem(at: indexPath) else {
                return
        }
        let cellFrameInSuperView = collectionView.convert(attributes.frame, to: collectionView.superview)
        transition.originFrame = cellFrameInSuperView
    }
}
