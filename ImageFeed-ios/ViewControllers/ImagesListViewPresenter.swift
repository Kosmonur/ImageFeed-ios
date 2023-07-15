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
    func imagesListServicePhoto(index: Int) -> Photo
    func imagesListServicePhotosCount() -> Int
    func photosCount() -> Int
    func changeLike(index: Int, cell: ImagesListCell)
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
                        
                        let oldCount = photos.count
                        let newCount = imagesListService.photos.count
                        photos = imagesListService.photos
                        if oldCount != newCount {
                            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
                        }
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
    
    func imagesListServicePhoto(index: Int) -> Photo {
        imagesListService.photos[index]
    }
    
    func imagesListServicePhotosCount() -> Int {
        imagesListService.photos.count
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func changeLike(index: Int, cell: ImagesListCell) {
        let photo = photos[index]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.photos[index].isLiked = self.imagesListServicePhoto(index: index).isLiked
                self.view?.setIsLiked(self.photos[index].isLiked, cell)
            case .failure(let error):
                print("Ошибка обновления лайка: \(error)")
            }
        }
    }
    
} 
