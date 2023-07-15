//
//  ImagesListViewPresenter.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 13.07.2023.
//

import Foundation

protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func needFetchPhotosNextPage(index: Int)
    func singleImageURLString(index: Int) -> String
    func getPhoto(index: Int) -> Photo
    func imagesListServicePhotosCount() -> Int
    func photosCount() -> Int
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService()
    private (set) var photos: [Photo] = []

    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ImagesListService.didChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self else { return }
                        view?.updateTableViewAnimated()
                    }
    }
    
    func needFetchPhotosNextPage(index: Int) {
        if index + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func singleImageURLString(index: Int) -> String {
        imagesListService.photos[index].largeImageURL
    }
    
    func getPhoto(index: Int) -> Photo {
        imagesListService.photos[index]
    }
    
    func imagesListServicePhotosCount() -> Int {
        imagesListService.photos.count
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    
} 
