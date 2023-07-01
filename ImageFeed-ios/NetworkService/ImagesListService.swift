//
//  ImagesListService.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 30.06.2023.
//

import Foundation

final class ImagesListService {
    
    private var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage(){
        
    }
    
}
