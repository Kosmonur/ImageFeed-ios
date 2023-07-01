//
//  PhotoResult.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 29.06.2023.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String?
    let width: String?
    let height: String?
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: String?
}

struct UrlsResult: Decodable {
    let full: String?
    let thumb: String?
}


