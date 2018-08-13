//
//  Photo.swift
//  PhotosGrid
//
//  Created by Jeffrey Ip on 2018-08-07.
//  Copyright © 2018 nil. All rights reserved.
//

import Foundation

class Photo {
    let creator: String
    let dateCreated: Date
    let photoID: String
    let imageURL: URL
    
    init(creator: String, dateCreated: Date, photoID: String, imageURL: URL) {
        self.creator = creator
        self.dateCreated = dateCreated
        self.photoID = photoID
        self.imageURL = imageURL
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
