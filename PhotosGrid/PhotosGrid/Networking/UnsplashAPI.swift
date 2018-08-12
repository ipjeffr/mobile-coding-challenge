//
//  UnsplashAPI.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-07.
//  Copyright © 2018 nil. All rights reserved.
//

import Foundation

enum UnsplashError: Error {
    case invalidJsonData
}

enum UnsplashAPIPath: String {
    case photos = "/photos/curated"
}

struct UnsplashAPI {
    private static let baseURLString = "https://api.unsplash.com/"
    private static let apiKey = "b2f3366c4372f8650108b6583ba7459cd6049faf40af36e70e5aa1064760eca5"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    static func photosURL(page: Int) -> URL {
        let pageParam = ["page": String(page)]
        return unsplashURL(path: .photos, parameters: pageParam)
    }
    
    private static func unsplashURL(path: UnsplashAPIPath,
                                    parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        components.path = path.rawValue
        var queryItems = [URLQueryItem]()
        let baseParams = ["client_id": apiKey]
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data,
                                                              options: [])
            
            guard let photosArray = jsonObject as? [[String: Any]] else {
                // The JSON structure doesn't match our expectations
                return .failure(UnsplashError.invalidJsonData)
            }

            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(fromJSON: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                // We weren't able to parse any of the photos
                // Maybe the JSON format for photos has changed
                return .failure(UnsplashError.invalidJsonData)
            }
            
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func photo(fromJSON json: [String: Any]) -> Photo? {
        guard let user = json["user"] as? [String: Any],
            let creator = user["name"] as? String,
            let photoID = json["id"] as? String,
            let dateCreatedString = json["created_at"] as? String,
            let dateCreated = dateFormatter.date(from: dateCreatedString),
            let imageUrlsDictionary = json["urls"] as? [String: String],
            let imageUrlString = imageUrlsDictionary["small"],
            let imageUrl = URL(string: imageUrlString) else {
                return nil
        }
        
        // Title sometimes returns null
        var title = ""
        if let _title = json["description"] as? String {
            title = _title
        }
        
        return Photo(creator: creator,
                     title: title,
                     photoID: photoID,
                     dateCreated: dateCreated,
                     imageURL: imageUrl)
    }
}
