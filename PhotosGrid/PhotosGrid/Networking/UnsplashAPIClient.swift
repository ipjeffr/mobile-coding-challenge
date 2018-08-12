//
//  UnsplashAPIClient.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-11.
//  Copyright © 2018 nil. All rights reserved.
//

import UIKit

enum ImageResult {
    case success(UIImage)
    case failure(Error)
}

enum PhotoError: Error {
    case imageCreationError
}

enum PhotosResult {
    case success([Photo])
    case failure(Error)
}

typealias TotalPhotos = Int

class UnsplashAPIClient {
    let imageStore = ImageStore()
    
    private let totalPhotosKey = "x-total"
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchPhotos(page: Int, completion: @escaping (PhotosResult, TotalPhotos) -> Void) {
        
        let url = UnsplashAPI.photosURL(page: page)
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            var totalPhotos = 0
            if let urlResponse = response as? HTTPURLResponse {
                let headers = urlResponse.allHeaderFields
                if let totalPhotosString = headers[self.totalPhotosKey] as? String {
                    totalPhotos = Int(totalPhotosString)!
                }
            }
            
            let result = self.processPhotosRequest(data: data, error: error)
            DispatchQueue.main.async {
                completion(result, totalPhotos)
            }
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return UnsplashAPI.photos(fromJSON: jsonData)
    }
    
    func fetchImage(for photo: Photo, completion: @escaping (ImageResult) -> Void) {
        
        let photoKey = photo.photoID
        if let image = imageStore.image(forKey: photoKey) {
            DispatchQueue.main.async {
                completion(.success(image))
            }
            return
        }
        
        let photoURL = photo.imageURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        guard let imageData = data,
            let image = UIImage(data: imageData) else {
                // Couldn't create an image
                if data == nil {
                    return .failure(error!)
                } else {
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }
}
