//
//  ProfileService.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 14.06.2023.
//

import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile (
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void) {
            
            assert(Thread.isMainThread)
            if lastToken == token { return }
            task?.cancel()
            lastToken = token
            
            let request = URLRequest.getRequest(token: token, path: "/me")
            let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let body):
                        let profile = Profile(profileResult: body)
                        self.profile = profile
                        completion(.success(profile))
                        self.task = nil
                    case .failure(let error):
                        completion(.failure(error))
                        self.lastToken = nil
                    }
                }
            }
            self.task = task
            task.resume()
        }
}
