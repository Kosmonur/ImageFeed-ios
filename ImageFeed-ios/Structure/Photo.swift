//
//  Photo.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 29.06.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id ?? ""
        self.size = CGSize(width: photoResult.width ?? 0, height: photoResult.height ?? 0)
        let dateFormatter = ISO8601DateFormatter()
        self.createdAt = dateFormatter.date(from:photoResult.createdAt ?? "")
        self.welcomeDescription = photoResult.description ?? ""
        self.thumbImageURL = photoResult.urls.thumb ?? ""
        self.largeImageURL = photoResult.urls.full ?? ""
        self.isLiked = photoResult.likedByUser ?? false
    }
}
