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
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUserName: String?
    private var lastToken: String?

    func fetchProfileImageURL(
        username: String,
        _ completion: @escaping (Result<String, Error>) -> Void) {
            
            guard let token = OAuth2TokenStorage.shared.token else { return }
            
            assert(Thread.isMainThread)

            if (lastUserName == username) || (lastToken == token) { return }
            task?.cancel()
            
            lastUserName = username
            lastToken = token

            let request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        let avatarURLString = image.profileImage.large
                        self.avatarURL = avatarURLString
                        completion(.success(avatarURLString))
                        NotificationCenter.default
                            .post(
                                name: ProfileImageService.DidChangeNotification,
                                object: self,
                                userInfo: ["URL": avatarURLString])
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.lastUserName = nil
                        self.lastToken = nil
                    }
                }
            }
            self.task = task
            task.resume()
        }
}
