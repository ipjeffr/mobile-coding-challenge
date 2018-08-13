//
//  PhotosPageViewController.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-12.
//  Copyright © 2018 nil. All rights reserved.
//

import UIKit

protocol PhotosPageViewControllerDelegate: class {
    func scrollToLastViewedCell(at index: Int)
}

class PhotosPageViewController: UIPageViewController {
    var photos: [Photo]!
    var currentIndex: Int!
    weak var visibleCellDelegate: PhotosPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewControllers()
        dataSource = self
        delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParentViewController {
            self.visibleCellDelegate?.scrollToLastViewedCell(at: currentIndex)
        }
    }
    
    private func setupViewControllers() {
        let viewController = viewPhotoInfoController(currentIndex)
        let viewControllers = [viewController]
        
        setViewControllers(viewControllers,
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }
    
    func viewPhotoInfoController(_ index: Int) -> PhotoInfoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let page = storyboard.instantiateViewController(withIdentifier: "PhotoInfoViewController")
                as! PhotoInfoViewController
        page.photo = photos[index]
        page.photoIndex = index
        return page
    }
}

extension PhotosPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? PhotoInfoViewController,
            let index = viewController.photoIndex,
            index > 0 {
            return viewPhotoInfoController(index - 1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? PhotoInfoViewController,
            let index = viewController.photoIndex,
            (index + 1) < photos.count {
            return viewPhotoInfoController(index + 1)
        }
        
        return nil
    }
}

extension PhotosPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        guard let index = (pageViewController.viewControllers?.first as? PhotoInfoViewController)?.photoIndex else {
            return
        }
        currentIndex = index
    }
}
