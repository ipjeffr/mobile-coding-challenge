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
    let remoteURLThumb: URL
    let remoteURLFull: URL
    
    init(creator: String, title: String, photoID: String, dateCreated: Date, remoteURLThumb: URL, remoteURLFull: URL) {
        self.creator = creator
        self.title = title
        self.photoID = photoID
        self.dateCreated = dateCreated
        self.remoteURLThumb = remoteURLThumb
        self.remoteURLFull = remoteURLFull
    }
}
