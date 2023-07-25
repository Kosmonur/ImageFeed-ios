//
//  ProfileService.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 14.06.2023.
//

import Foundation

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String
    init(profileResult: ProfileResult) {
        self.userName = profileResult.username ?? ""
        self.name = "\(profileResult.firstName ?? "") \(profileResult.lastName ?? "")"
        self.loginName = "@\(profileResult.username ?? "")"
        self.bio = profileResult.bio ?? ""
    }
}

struct ProfileResult: Decodable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
}

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile (
        completion: @escaping (Result<Profile, Error>) -> Void) {
            
            guard let token = OAuth2TokenStorage.shared.token else { return }
            
            assert(Thread.isMainThread)
            if lastToken == token { return }
            task?.cancel()
            lastToken = token
            
            let request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
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
                        self.task = nil
                    }
                }
            }
            self.task = task
            task.resume()
        }
}
