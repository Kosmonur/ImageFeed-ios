//
//  OAuth2TokenStorage.swift
//  ImageFeed-ios
//
//  Created by Александр Пичугин on 31.05.2023.
//

import Foundation

final class OAuth2TokenStorage {

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "bearer_token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "bearer_token")
        }
    }
}
