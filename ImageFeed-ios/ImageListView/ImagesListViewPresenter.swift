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
    func needFetchPhotosNextPage(_ index: Int)
    func singleImageURLString(_ index: Int) -> String
    func imagesListServicePhoto(_ index: Int) -> Photo
    func imagesListServicePhotosCount() -> Int
    func photosCount() -> Int
    func changeLike(_ index: Int, _ cell: ImagesListCell)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    private let imagesListService = ImagesListService()
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []

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
                        photos = imagesListService.photos
                        let newCount = photos.count
                        if oldCount != newCount {
                            view?.updateTableViewAnimated(oldCount, newCount)
                        }
                    }
    }
    
    func needFetchPhotosNextPage(_ index: Int) {
        if index + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func singleImageURLString(_ index: Int) -> String {
        imagesListService.photos[index].largeImageURL
    }
    
    func imagesListServicePhoto(_ index: Int) -> Photo {
        imagesListService.photos[index]
    }
    
    func imagesListServicePhotosCount() -> Int {
        imagesListService.photos.count
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func changeLike(_ index: Int, _ cell: ImagesListCell) {
        let photo = photos[index]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {[weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.photos[index].isLiked = self.imagesListServicePhoto(index).isLiked
                self.view?.setIsLiked(self.photos[index].isLiked, cell)
            case .failure(let error):
                print("Ошибка обновления лайка: \(error)")
            }
        }
    }
    
} 
