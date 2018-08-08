//
//  PhotoStore.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-07.
//  Copyright © 2018 nil. All rights reserved.
//

import Foundation

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

class PhotoStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchPhotos(completion: @escaping (PhotosResult) -> Void) {
        let url = UnsplashAPI.photosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return UnsplashAPI.photos(fromJSON: jsonData)
    }
}
