//
//  OAuth2TokenStorage.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 31.05.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    let tokenKey = "bearer_token"
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            guard let token = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenKey)
            guard isSuccess else {
                print ("Ошибка записи токена")
                return
            }
        }
    }
    
    func removeToken() {
        let isSuccess = KeychainWrapper.standard.removeObject(forKey: tokenKey)
        guard isSuccess else {
            print ("Ошибка удаления токена")
            return
        }
    }
}

