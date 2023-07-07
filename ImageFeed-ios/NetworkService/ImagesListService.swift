//
//  ImagesListService.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 30.06.2023.
//

import Foundation

private let dateFormatter = ISO8601DateFormatter()

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}

private struct PhotoResult: Decodable {
    let id: String?
    let width: Int?
    let height: Int?
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool?
    
    func convertToViewModel() -> Photo {
        return Photo (
            id: id ?? "",
            size: CGSize(width: width ?? 0, height: height ?? 0),
            createdAt: dateFormatter.date(from: createdAt ?? ""),
            welcomeDescription: description ?? "",
            thumbImageURL: urls.thumb ?? "",
            largeImageURL: urls.full ?? "",
            isLiked: likedByUser ?? false)
    }
}

private struct LikeResult: Decodable {
    let photo: PhotoResult
}

struct UrlsResult: Decodable {
    let full: String?
    let thumb: String?
}

final class ImagesListService {
    
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private var liketask: URLSessionTask?
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage(){

        assert(Thread.isMainThread)
        task?.cancel()
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        let request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)&&per_page=10", httpMethod: "GET")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let loadedPhotoResult):
                    self.photos += loadedPhotoResult.map({$0.convertToViewModel()})
                    
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
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
                        self.photos[index].isLiked = likeResult.photo.convertToViewModel().isLiked
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

