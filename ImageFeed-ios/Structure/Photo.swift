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
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id ?? ""
        self.size = CGSize(width: Int(photoResult.width ?? "0") ?? 0, height: Int(photoResult.width ?? "0") ?? 0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        self.createdAt = dateFormatter.date(from:photoResult.createdAt!) ?? nil
        self.welcomeDescription = photoResult.description
        self.thumbImageURL = photoResult.urls.thumb ?? ""
        self.largeImageURL = photoResult.urls.full ?? ""
        self.isLiked = (photoResult.likedByUser == "true") ? true : false
    }
}