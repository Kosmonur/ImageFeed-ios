//
//  URLSessionExtension.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 18.06.2023.
//

import Foundation

// MARK: - Network Connection
enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

// MARK: - HTTP Request
extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL) ?? baseURL)
        request.httpMethod = httpMethod
        
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")}
        return request
    }
}

extension URLSession {

func objectTask<T: Decodable>(
    for request: URLRequest,
    completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
    let fulfillCompletion: (Result<T, Error>) -> Void = { result in
        DispatchQueue.main.async {
            completion(result)
        }
    }
        let task = dataTask(with: request) { data, response, error in
            
            if let error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                
                if let data,
                   let response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    
                    if (200 ..< 300).contains(statusCode) {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let decodedData = try decoder.decode(T.self, from: data)
                            fulfillCompletion(.success(decodedData))
                        } catch {
                            fulfillCompletion(.failure(error))
                        }
                    } else {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                }
            }
        }
        return task
    }
}

