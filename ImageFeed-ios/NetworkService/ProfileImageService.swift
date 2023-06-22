//
//  ProfileImageService.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 17.06.2023.
//

import UIKit

final class ProfileImageService {
    
    struct UserResult: Decodable {
        let profileImage: ProfileImage
    }
    struct ProfileImage: Decodable {
        let large: String
    }
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private var tokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUserName: String?

    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void) {
            
            assert(Thread.isMainThread)
            guard let token = tokenStorage.token else { return }
            if lastUserName == username { return }
            task?.cancel()
            lastUserName = username

            let request = URLRequest.getRequest(token: token, path: "/users/\(username)")
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        let avatar = image.profileImage.large
                        self.avatarURL = avatar
                        completion(.success(avatar))
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.DidChangeNotification,
                                object: self,
                                userInfo: ["URL": avatar])
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.lastUserName = nil
                    }
                }
            }
            self.task = task
            task.resume()
        }
}
