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
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage(){

        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        let request = URLRequest.getRequest(path: "/photos?page=\(nextPage)&&per_page=10")
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
                    // TODO
                    print("Ошибка загрузки массива картинок:", error)
                    self.task = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
}
