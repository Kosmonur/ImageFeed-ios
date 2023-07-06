//
//  ImagesListService.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 30.06.2023.
//

import Foundation

final class ImagesListService {
    
    static let shared = ImagesListService()
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private var liketask: URLSessionTask?
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage(){

        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        let request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)&&per_page=10", httpMethod: "GET")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let loadedPhotoResult):
                    self.photos += loadedPhotoResult.map({Photo(photoResult: $0)})
                    
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["photos": self.photos])
                    
                    self.lastLoadedPage = nextPage
                    self.task = nil
                    
                case .failure(let error):
                    print("Ошибка загрузки массива картинок:", error)
                    self.task = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        liketask?.cancel()

        let httpMethod = isLike ? "DELETE" : "POST"
        let request = URLRequest.makeHTTPRequest(path: "/photos/\(photoId)/like", httpMethod: httpMethod)
        
        let liketask = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let likeResult):
                    let photoId = likeResult.photo.id
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        self.photos[index].isLiked = !isLike
                    }
                    completion (.success(()))
                    self.liketask = nil
                    
                case .failure(let error):
                    completion (.failure(error))
                    self.liketask = nil
                }
            }
        }
        
        self.liketask = liketask
        liketask.resume()
    }
}

