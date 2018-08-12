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
    let title: String
    let photoID: String
    let dateCreated: Date
    let imageURL: URL
    
    init(creator: String, title: String, photoID: String, dateCreated: Date, imageURL: URL) {
        self.creator = creator
        self.title = title
        self.photoID = photoID
        self.dateCreated = dateCreated
        self.imageURL = imageURL
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
