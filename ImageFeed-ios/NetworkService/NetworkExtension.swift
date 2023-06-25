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
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL) ?? baseURL)
        request.httpMethod = httpMethod
        return request
    }
    
    static func getRequest(token: String, path: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(
            path: path,
            httpMethod: "GET"
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

extension URLSession {

    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {

            let task = dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    
                    if let error {
                        completion(.failure(NetworkError.urlRequestError(error)))
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse,
                       !(200 ..< 300).contains(response.statusCode) {
                        completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                        return
                       }
                       
                    guard let data else { return }
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let decodedData = try decoder.decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(NetworkError.urlSessionError))
                    }
                }
            }
            return task
        }
}
