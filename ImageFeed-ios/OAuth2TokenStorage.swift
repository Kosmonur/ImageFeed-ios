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
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "bearer_token")
        }
        set {
            guard let token = newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: "bearer_token")
            guard isSuccess else { return }
        }
    }
}
